//
//  PhotoCaptureDelegate.swift
//  Keyneez
//
//  Created by Jung peter on 1/8/23.
//

import AVFoundation
import Photos
import CoreVideo
import MLImage
import MLKitTextRecognitionKorean
import MLKitTextRecognition
import MLKit

class PhotoCaptureProcessor: NSObject {
  private(set) var requestedPhotoSettings: AVCapturePhotoSettings
  
  private let willCapturePhotoAnimation: () -> Void
  
  private let livePhotoCaptureHandler: (Bool) -> Void
  
  lazy var context = CIContext()
  
  private let completionHandler: (PhotoCaptureProcessor) -> Void
  
  private let photoProcessingHandler: (Bool) -> Void
  
  private let OCRCompletionHandler: ([String], UIImage) -> Void
  
  private var photoData: Data?
  
  private var livePhotoCompanionMovieURL: URL?
  
  private var portraitEffectsMatteData: Data?
  
  private var semanticSegmentationMatteDataArray = [Data]()
  private var maxPhotoProcessingTime: CMTime?
  
  
  
  // Save the location of captured photos
  var location: CLLocation?
  var koreanOptions = KoreanTextRecognizerOptions()
  
  init(with requestedPhotoSettings: AVCapturePhotoSettings,
       willCapturePhotoAnimation: @escaping () -> Void,
       livePhotoCaptureHandler: @escaping (Bool) -> Void,
       completionHandler: @escaping (PhotoCaptureProcessor) -> Void,
       photoProcessingHandler: @escaping (Bool) -> Void,
       OCRCompletionHandler: @escaping ([String], UIImage) -> Void
  ) {
    self.requestedPhotoSettings = requestedPhotoSettings
    self.willCapturePhotoAnimation = willCapturePhotoAnimation
    self.livePhotoCaptureHandler = livePhotoCaptureHandler
    self.completionHandler = completionHandler
    self.photoProcessingHandler = photoProcessingHandler
    self.OCRCompletionHandler = OCRCompletionHandler
  }
  
  private func didFinish() {
    if let livePhotoCompanionMoviePath = livePhotoCompanionMovieURL?.path {
      if FileManager.default.fileExists(atPath: livePhotoCompanionMoviePath) {
        do {
          try FileManager.default.removeItem(atPath: livePhotoCompanionMoviePath)
        } catch {
          print("Could not remove file at url: \(livePhotoCompanionMoviePath)")
        }
      }
    }
    
    completionHandler(self)
  }
}

extension PhotoCaptureProcessor: AVCapturePhotoCaptureDelegate {
  /*
   This extension adopts all of the AVCapturePhotoCaptureDelegate protocol methods.
   */
  
  /// - Tag: WillBeginCapture
  func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    if resolvedSettings.livePhotoMovieDimensions.width > 0 && resolvedSettings.livePhotoMovieDimensions.height > 0 {
      livePhotoCaptureHandler(true)
    }
    maxPhotoProcessingTime = resolvedSettings.photoProcessingTimeRange.start + resolvedSettings.photoProcessingTimeRange.duration
  }
  
  /// - Tag: WillCapturePhoto
  func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    willCapturePhotoAnimation()
    
    guard let maxPhotoProcessingTime = maxPhotoProcessingTime else {
      return
    }
    
    // Show a spinner if processing time exceeds one second.
    let oneSecond = CMTime(seconds: 1, preferredTimescale: 1)
    if maxPhotoProcessingTime > oneSecond {
      photoProcessingHandler(true)
    }
  }
  
  /// - Tag: DidFinishProcessingPhoto
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    photoProcessingHandler(false)
    
    if let error = error {
      print("Error capturing photo: \(error)")
      return
    } else {
      //      photoData = photo.fileDataRepresentation()
      guard let data = photo.fileDataRepresentation() else {return}
      guard let tempImage = UIImage(data: data) else {return}
      
      let deviceScreen = UIScreen.main.bounds.size
      var newImage = UIImage(cgImage: resizeImage(image: tempImage, size: tempImage.size))
      let newx = regionOfInterestSize.origin.x / deviceScreen.height * tempImage.size.height
      let newy = regionOfInterestSize.origin.y / deviceScreen.height * tempImage.size.height
      let newHeight = regionOfInterestSize.height / deviceScreen.height * tempImage.size.height
      let newWidth = newHeight * regionOfInterestSize.width / regionOfInterestSize.height
      var cropped = newImage.cgImage?.cropping(to: CGRect(x: tempImage.size.width / 2 - newWidth / 2, y: newy, width: newHeight * regionOfInterestSize.width / regionOfInterestSize.height, height: newHeight))
      
      var newCropped = UIImage(cgImage: cropped!, scale: newImage.scale, orientation: newImage.imageOrientation)
      
      photoData = newCropped.pngData()
      
      DispatchQueue.global().async { [weak self] in
        guard let self = self else {return}
        let visionImage = VisionImage(image: newCropped)
        OCRService().recognizeTextWithManual(in: visionImage, with: newCropped, width: newCropped.size.width, height: newCropped.size.height) { text, image in
          self.OCRCompletionHandler(text, image)
        }
        
      }
    }
    
  }
  
  /// - Tag: DidFinishRecordingLive
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishRecordingLivePhotoMovieForEventualFileAt outputFileURL: URL, resolvedSettings: AVCaptureResolvedPhotoSettings) {
    livePhotoCaptureHandler(false)
  }
  
  /// - Tag: DidFinishProcessingLive
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL, duration: CMTime, photoDisplayTime: CMTime, resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
    if error != nil {
      print("Error processing Live Photo companion movie: \(String(describing: error))")
      return
    }
    livePhotoCompanionMovieURL = outputFileURL
  }
  
  /// - Tag: DidFinishCapture
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
    if let error = error {
      print("Error capturing photo: \(error)")
      didFinish()
      return
    }
    
    guard let photoData = photoData else {
      print("No photo data resource")
      didFinish()
      return
    }
  }
  
  func resizeImage(image: UIImage, size: CGSize) -> CGImage {
    UIGraphicsBeginImageContext(size)
    image.draw(in:CGRect(x: 0, y: 0, width: size.width, height:size.height))
    let renderImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let resultImage = renderImage?.cgImage else {
      print("image resizing error")
      return UIImage().cgImage!
    }
    return resultImage
  }
  
}

extension CGImage {
  var png: Data? {
    guard let mutableData = CFDataCreateMutable(nil, 0),
          let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil) else { return nil }
    CGImageDestinationAddImage(destination, self, nil)
    guard CGImageDestinationFinalize(destination) else { return nil }
    return mutableData as Data
  }
}
