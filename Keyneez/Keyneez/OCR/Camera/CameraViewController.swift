//
//  CameraViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/7/23.
//

import UIKit
import AVFoundation
import SnapKit

private enum SessionSetupResult {
  case success
  case notAuthorized
  case configurationFailed
}

private enum LivePhotoMode {
  case on
  case off
}

private enum DepthDataDeliveryMode {
  case on
  case off
}

private enum PortraitEffectsMatteDeliveryMode {
  case on
  case off
}

final class CameraViewController: NiblessViewController {
  
  // 커스텀 네비게이션 뷰 생성
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: []).build()
  
  private var previewView: PreviewView = .init()
  
  private var videoDeviceInput: AVCaptureDeviceInput!
  
  private let sessionQueue = DispatchQueue(label: "session queue")
  private let session = AVCaptureSession()
  private var isSessionRunning = false
  private var selectedSemanticSegmentationMatteTypes = [AVSemanticSegmentationMatte.MatteType]()
  
  private var setupResult: SessionSetupResult = .success
  var windowOrientation: UIInterfaceOrientation {
    return view.window?.windowScene?.interfaceOrientation ?? .unknown
  }
  
  private let photoOutput = AVCapturePhotoOutput()
  private var inProgressPhotoCaptureDelegates = [Int64: PhotoCaptureProcessor]()
  private var inProgressLivePhotoCapturesCount = 0
  
  private var cameraButton: UIButton = .init()
  private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera, .builtInDualWideCamera],
                                                                             mediaType: .video, position: .unspecified)
  
  private var livePhotoMode: LivePhotoMode = .off
  private var depthDataDeliveryMode: DepthDataDeliveryMode = .off
  private var portraitEffectsMatteDeliveryMode: PortraitEffectsMatteDeliveryMode = .off
  // 이건뭐임?
  private var photoQualityPrioritizationMode: AVCapturePhotoOutput.QualityPrioritization = .balanced
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubviews(previewView)
    previewView.snp.makeConstraints {
      $0.top.bottom.left.right.equalToSuperview()
    }
    previewView.session = session
    checkCameraAuthroizationStatus()
    sessionQueue.async {
      self.configureSession()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    sessionQueue.async {
        switch self.setupResult {
        case .success:
            // Only setup observers and start the session if setup succeeded.
            self.session.startRunning()
            self.isSessionRunning = self.session.isRunning
            
        case .notAuthorized:
            DispatchQueue.main.async {
                let changePrivacySetting = "키니즈 ID서비스를 사용하려면 '카메라' 접근권한을 허용해야 해요."
              let message = NSLocalizedString(changePrivacySetting, comment: "키니즈 ID서비스를 사용하려면 '카메라' 접근권한을 허용해야 해요.")
                let alertController = UIAlertController(title: "키니즈", message: message, preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                        style: .cancel,
                                                        handler: nil))
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"),
                                                        style: .`default`,
                                                        handler: { _ in
                                                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                                                      options: [:],
                                                                                      completionHandler: nil)
                }))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        case .configurationFailed:
            DispatchQueue.main.async {
                let alertMsg = "Alert message when something goes wrong during capture session configuration"
                let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
                let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                        style: .cancel,
                                                        handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
  }
  
}

// MARK: - Configure Session
extension CameraViewController {
  
  private func configureSession() {
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
        addDeviceInputToSession(with: videoDeviceInput)
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
  
  private func addDeviceInputToSession(with deviceInput: AVCaptureDeviceInput) {
    session.addInput(deviceInput)
    self.videoDeviceInput = deviceInput
    
    DispatchQueue.main.async {
      // 휴대폰 오리엔테이션에 기반해서 변경되는것은 mainQueue에서 진행
      
      var initialVideoOrientation: AVCaptureVideoOrientation = .portrait
      if self.windowOrientation != .unknown {
          if let videoOrientation = AVCaptureVideoOrientation(interfaceOrientation: self.windowOrientation) {
              initialVideoOrientation = videoOrientation
          }
      }
      
      self.previewView.videoPreviewLayer.connection?.videoOrientation = initialVideoOrientation
      
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


// MARK: - Capture Photo
extension CameraViewController {
  
  func capturePhoto() {
    
    let videoPreviewLayerOrientation = previewView.videoPreviewLayer.connection?.videoOrientation
    
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
          photoSettings.enabledSemanticSegmentationMatteTypes = self.selectedSemanticSegmentationMatteTypes
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
      }, photoProcessingHandler: { animate in
        // Animates a spinner while photo is processing
        DispatchQueue.main.async {
          //TODO: 여기에 이미지 처리할때 어떻게 처리할지 정의
        }
      })
      
      // 사진이 어디에 저장되는지 정하기
      //      photoCaptureProcessor.location = self.locationManager.location
      
      // The photo output holds a weak reference to the photo capture delegate and stores it in an array to maintain a strong reference.
      self.inProgressPhotoCaptureDelegates[photoCaptureProcessor.requestedPhotoSettings.uniqueID] = photoCaptureProcessor
      self.photoOutput.capturePhoto(with: photoSettings, delegate: photoCaptureProcessor)
      
    }
    
  }
  
}

// MARK: - Add PhotoOutput
extension CameraViewController {
  
  func addPhotoOutput() {
    if session.canAddOutput(photoOutput) {
      session.addOutput(photoOutput)
      
      photoOutput.isHighResolutionCaptureEnabled = true
      photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
      photoOutput.isDepthDataDeliveryEnabled = photoOutput.isDepthDataDeliverySupported
      photoOutput.isPortraitEffectsMatteDeliveryEnabled = photoOutput.isPortraitEffectsMatteDeliverySupported
      photoOutput.enabledSemanticSegmentationMatteTypes = photoOutput.availableSemanticSegmentationMatteTypes
      selectedSemanticSegmentationMatteTypes = photoOutput.availableSemanticSegmentationMatteTypes
      photoOutput.maxPhotoQualityPrioritization = .quality
      livePhotoMode = photoOutput.isLivePhotoCaptureSupported ? .on : .off
      depthDataDeliveryMode = photoOutput.isDepthDataDeliverySupported ? .on : .off
      portraitEffectsMatteDeliveryMode = photoOutput.isPortraitEffectsMatteDeliverySupported ? .on : .off
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

// MARK: - Resume Interruputed Session

extension CameraViewController {
  
  func resume() {
    sessionQueue.async {
      self.session.startRunning()
      self.isSessionRunning = self.session.isRunning
      if !self.session.isRunning {
        DispatchQueue.main.async {
          let message = NSLocalizedString("Unable to resume", comment: "Alert message when unable to resume the session running")
          let alertController = UIAlertController(title: "키니즈", message: message, preferredStyle: .alert)
          let cancelAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil)
          alertController.addAction(cancelAction)
          self.present(alertController, animated: true, completion: nil)
        }
      } else {
        //TODO: 여기에 resumeButton 추가
        DispatchQueue.main.async {
          //          self.resumeButton.isHidden = true
        }
      }
    }
  }
  
}

// MARK: - Check Authorization

extension CameraViewController {
  
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

extension AVCaptureVideoOrientation {
    init?(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeRight
        case .landscapeRight: self = .landscapeLeft
        default: return nil
        }
    }
    
    init?(interfaceOrientation: UIInterfaceOrientation) {
        switch interfaceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeLeft
        case .landscapeRight: self = .landscapeRight
        default: return nil
        }
    }
}

extension AVCaptureDevice.DiscoverySession {
    var uniqueDevicePositionsCount: Int {
        
        var uniqueDevicePositions = [AVCaptureDevice.Position]()
        
        for device in devices where !uniqueDevicePositions.contains(device.position) {
            uniqueDevicePositions.append(device.position)
        }
        
        return uniqueDevicePositions.count
    }
}
