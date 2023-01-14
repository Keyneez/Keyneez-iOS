//
//  Camera.swift
//  Keyneez
//
//  Created by Jung peter on 1/10/23.
//

import AVFoundation
import MLKitTextRecognitionKorean
import MLKitTextRecognition
import MLKit
import MLImage
import CoreVideo

import UIKit

private enum Constant {
  static let videoDataOutputQueueLabel = "VideoDataOutputQueue"
  static let sessionQueueLabel = "textrecognizer.SessionQueue"
}

final class Camera {
  
  private var videoDeviceInput: AVCaptureDeviceInput!
  
  let sessionQueue = DispatchQueue(label: "session queue")
  let session = AVCaptureSession()
  private var isSessionRunning = false
  
  private var setupResult: SessionSetupResult = .success
  
  private let photoOutput = AVCapturePhotoOutput()
  private var inProgressPhotoCaptureDelegates = [Int64: PhotoCaptureProcessor]()
  private var inProgressLivePhotoCapturesCount = 0
  
  private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera, .builtInDualWideCamera],
                                                                             mediaType: .video, position: .unspecified)
  
  private var livePhotoMode: LivePhotoMode = .off
  private var depthDataDeliveryMode: DepthDataDeliveryMode = .off
  private var portraitEffectsMatteDeliveryMode: PortraitEffectsMatteDeliveryMode = .off
  // 이건뭐임?
  private var photoQualityPrioritizationMode: AVCapturePhotoOutput.QualityPrioritization = .balanced
  
  var lastFrame: CMSampleBuffer?
  
  private var koreanOptions = KoreanTextRecognizerOptions()
  
  private func updatePreviewOverlayViewWithLastFrame() {
    
    DispatchQueue.main.async { [weak self] in
      
      guard let self else {
        print("Self is nil")
        return
      }
      
      guard let lastFrame = self.lastFrame, let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame) else {return}
      
      self.updatePreviewOverlayViewWithImageBuffer(imageBuffer)
//      self.removeDetectionAnnotations()
      
    }
  }
  
  private func updatePreviewOverlayViewWithImageBuffer(_ imageBuffer: CVImageBuffer?) {
    guard let imageBuffer = imageBuffer else { return }
    let orientation: UIImage.Orientation = .leftMirrored
    let image = UIUtilities.createUIImage(from: imageBuffer, orientation: orientation)
    print(image)
  }
  
  
  init() {
    checkCameraAuthroizationStatus()
  }
  
  func configure(completionWhenAddInput: @escaping () -> Void) {
    sessionQueue.async {
      self.configureSession(completionWhenAddInput: completionWhenAddInput)
    }
  }
  
  func resume(sessionNotRunningcompletion: (() -> Void)?, sessionRunningCompletion: (() -> Void)?) {
    sessionQueue.async {
      self.session.startRunning()
      self.isSessionRunning = self.session.isRunning
      if !self.session.isRunning {
        DispatchQueue.main.async {
          sessionNotRunningcompletion?()
        }
      } else {
        // TODO: 여기에 resumeButton 추가
        DispatchQueue.main.async {
          sessionRunningCompletion?()
          //          self.resumeButton.isHidden = true
        }
      }
    }
  }
  
}

extension Camera {
  func checkSetupResult() {
    sessionQueue.async {
        switch self.setupResult {
        case .success:
            // Only setup observers and start the session if setup succeeded.
            self.session.startRunning()
            self.isSessionRunning = self.session.isRunning
            
        case .notAuthorized:
            DispatchQueue.main.async { self.ifNotAuthorized() }
        case .configurationFailed:
            DispatchQueue.main.async { self.ifConfigureFailed() }
        }
    }
  }
  
  private func ifConfigureFailed() {
    let alertMsg = "Alert message when something goes wrong during capture session configuration"
    let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
    let alertController = UIAlertController(title: "키니즈", message: message, preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                            style: .cancel,
                                            handler: nil))
    
//    self.present(alertController, animated: true, completion: nil)
  }
  
  private func ifNotAuthorized() {
    let changePrivacySetting = "키니즈 ID서비스를 사용하려면 '카메라' 접근권한을 허용해야 해요."
    let message = NSLocalizedString(changePrivacySetting, comment: "키니즈 ID서비스를 사용하려면 '카메라' 접근권한을 허용해야 해요.")
    let alertController = UIAlertController(title: "키니즈", message: message, preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                            style: .cancel,
                                            handler: nil))
    
    alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "카메라 설정가기"),
                                            style: .`default`,
                                            handler: { _ in
                                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                                          options: [:],
                                                                          completionHandler: nil)
    }))
    
//    self.present(alertController, animated: true, completion: nil)
  }
}

extension Camera {
  
  private func configureSession(completionWhenAddInput: @escaping () -> Void) {
    if setupResult != .success { return }
    
    session.beginConfiguration()
    session.sessionPreset = .photo
    
    // 하드웨어 자원 연결하기 (Add video Input)
    do {
      var defaultVideoDevice: AVCaptureDevice? = findAvailableDevice()
      guard let videoDevice = defaultVideoDevice else {
        print("Default video device is unavailable")
        setupResult = .configurationFailed
        session.commitConfiguration()
        return
      }
      
      // 가능한 하드웨어 찾음
      let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
      
      // 하드웨어 세션에 연결하기
      if session.canAddInput(videoDeviceInput) {
        addDeviceInputToSession(with: videoDeviceInput, completion: completionWhenAddInput)
      } else {
        print("디바이스를 session에 연결할 수 없습니다.")
        setupResult = .configurationFailed
        session.commitConfiguration()
        return
      }
    } catch {
      print("이 디바이스 Input을 만들수 없습니다.: \(error)")
      setupResult = .configurationFailed
      session.commitConfiguration()
      return
    }
    
    // photoOutput연결하기
    addPhotoOutput()
  }
  
 
  private func addDeviceInputToSession(with deviceInput: AVCaptureDeviceInput, completion: @escaping () -> Void) {
    session.addInput(deviceInput)
    self.videoDeviceInput = deviceInput
    
    DispatchQueue.main.async {
      // 휴대폰 오리엔테이션에 기반해서 변경되는것은 mainQueue에서 진행
      completion()
    }
    
  }
  
  private func findAvailableDevice() -> AVCaptureDevice? {
    if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
      return dualCameraDevice
    } else if let dualWideCameraDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) {
      return dualWideCameraDevice
    } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
      return backCameraDevice
    } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
      return frontCameraDevice
    }
    return nil
  }
}

extension Camera {
  
  private func checkCameraAuthroizationStatus() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      break
    case .denied:
      break
    case .restricted:
      break
    case .notDetermined:
      sessionQueue.suspend()
      AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
        if !granted {
          self.setupResult = .notAuthorized
        }
        self.sessionQueue.resume()
      })
    default:
      setupResult = .notAuthorized
    }
  }
}

// MARK: - Capture Photo

extension Camera {
  
  func capturePhoto(videoPreviewLayerOrientation: AVCaptureVideoOrientation?, photoCompletion: @escaping( [String], UIImage) -> Void) {
    
    sessionQueue.async {
      if let photoOutputConnection = self.photoOutput.connection(with: .video) {
        photoOutputConnection.videoOrientation = videoPreviewLayerOrientation!
      }
      var photoSettings = AVCapturePhotoSettings()
      
      if self.photoOutput.availablePhotoCodecTypes.contains(.hevc) {
        photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
      }
      
      photoSettings.flashMode = .off
      
      photoSettings.isDepthDataDeliveryEnabled = (self.depthDataDeliveryMode == .on
                                                  && self.photoOutput.isDepthDataDeliveryEnabled)
      
      photoSettings.isPortraitEffectsMatteDeliveryEnabled = (self.portraitEffectsMatteDeliveryMode == .on
                                                             && self.photoOutput.isPortraitEffectsMatteDeliveryEnabled)
      
      if photoSettings.isDepthDataDeliveryEnabled {
        if !self.photoOutput.availableSemanticSegmentationMatteTypes.isEmpty {
        }
      }
      
      photoSettings.photoQualityPrioritization = self.photoQualityPrioritizationMode
      
      let photoCaptureProcessor = PhotoCaptureProcessor(with: photoSettings,
                                                        willCapturePhotoAnimation: { },
                                                        livePhotoCaptureHandler: { capturing in
        self.sessionQueue.async {
          if capturing {
            self.inProgressLivePhotoCapturesCount += 1
          } else {
            self.inProgressLivePhotoCapturesCount -= 1
          }
          
          let inProgressLivePhotoCapturesCount = self.inProgressLivePhotoCapturesCount
          DispatchQueue.main.async {
            if inProgressLivePhotoCapturesCount > 0 {
//              self.capturingLivePhotoLabel.isHidden = false
            } else if inProgressLivePhotoCapturesCount == 0 {
//              self.capturingLivePhotoLabel.isHidden = true
            } else {
              print("Error: In progress Live Photo capture count is less than 0.")
            }
          }
        }
      }, completionHandler: { photoCaptureProcessor in
        // When the capture is complete, remove a reference to the photo capture delegate so it can be deallocated.
        self.sessionQueue.async {
          self.inProgressPhotoCaptureDelegates[photoCaptureProcessor.requestedPhotoSettings.uniqueID] = nil
        }
      }, photoProcessingHandler: { _ in
        // Animates a spinner while photo is processing
        
        
      }, OCRCompletionHandler: { text, image in
        photoCompletion(text, image)
      })
      

      self.inProgressPhotoCaptureDelegates[photoCaptureProcessor.requestedPhotoSettings.uniqueID] = photoCaptureProcessor
      self.photoOutput.capturePhoto(with: photoSettings, delegate: photoCaptureProcessor)
      
    }
    
  }
}

// MARK: - Add Output

extension Camera {

  func addPhotoOutput() {
    if session.canAddOutput(photoOutput) {
      session.addOutput(photoOutput)
    
      photoOutput.isHighResolutionCaptureEnabled = true
      photoOutput.maxPhotoQualityPrioritization = .quality
      photoQualityPrioritizationMode = .balanced
      
    } else {
      print("포토output을 세션에 추가할 수 없습니다.")
      setupResult = .configurationFailed
      session.commitConfiguration()
      return
    }
    
    session.commitConfiguration()
  }
}
