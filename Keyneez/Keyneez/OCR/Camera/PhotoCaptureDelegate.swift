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
       photoProcessingHandler: @escaping (Bool) -> Void) {
    self.requestedPhotoSettings = requestedPhotoSettings
    self.willCapturePhotoAnimation = willCapturePhotoAnimation
    self.livePhotoCaptureHandler = livePhotoCaptureHandler
    self.completionHandler = completionHandler
    self.photoProcessingHandler = photoProcessingHandler
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

extension PhotoCaptureProcessor {
  private func recognizeText(in image: VisionImage, width: CGFloat, height: CGFloat) {
    var recognizedText: Text
    do {
      recognizedText = try TextRecognizer.textRecognizer(options: koreanOptions)
        .results(in: image)
      print(recognizedText.text)
    } catch {
      print("Failed to recognize text with error: \(error.localizedDescription).")
      //      self.updatePreviewOverlayViewWithLastFrame()
      return
    }
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
        OCRService().recognizeText(in: visionImage, with: newCropped, width: newCropped.size.width, height: newCropped.size.height) { str, image in
          print(str)
        }
        
      }
    }
    
  }
  
  private func cropImage( image:UIImage , cropRect: CGRect) -> UIImage
  {
    UIGraphicsBeginImageContextWithOptions(cropRect.size, false, 0)
    let context = UIGraphicsGetCurrentContext()
    
    context?.translateBy(x: 0.0, y: image.size.height)
    context?.scaleBy(x: 1.0, y: -1.0)
    print("변경된", image.size)
    context?.draw(image.cgImage!, in: CGRect(x:0, y:0, width:image.size.width, height:image.size.height), byTiling: false)
    context?.clip(to: [cropRect])
    
    let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return croppedImage!
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
    
    PHPhotoLibrary.requestAuthorization { status in
      if status == .authorized {
        PHPhotoLibrary.shared().performChanges({
          let options = PHAssetResourceCreationOptions()
          let creationRequest = PHAssetCreationRequest.forAsset()
          options.uniformTypeIdentifier = self.requestedPhotoSettings.processedFileType.map { $0.rawValue }
          creationRequest.addResource(with: .photo, data: photoData, options: options)
          
          // Specify the location the photo was taken
          creationRequest.location = self.location
          
          if let livePhotoCompanionMovieURL = self.livePhotoCompanionMovieURL {
            let livePhotoCompanionMovieFileOptions = PHAssetResourceCreationOptions()
            livePhotoCompanionMovieFileOptions.shouldMoveFile = true
            creationRequest.addResource(with: .pairedVideo,
                                        fileURL: livePhotoCompanionMovieURL,
                                        options: livePhotoCompanionMovieFileOptions)
          }
          
          // Save Portrait Effects Matte to Photos Library only if it was generated
          if let portraitEffectsMatteData = self.portraitEffectsMatteData {
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo,
                                        data: portraitEffectsMatteData,
                                        options: nil)
          }
          // Save Portrait Effects Matte to Photos Library only if it was generated
          for semanticSegmentationMatteData in self.semanticSegmentationMatteDataArray {
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo,
                                        data: semanticSegmentationMatteData,
                                        options: nil)
          }
          
        }, completionHandler: { _, error in
          if let error = error {
            print("Error occurred while saving photo to photo library: \(error)")
          }
          
          self.didFinish()
        }
        )
      } else {
        self.didFinish()
      }
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
