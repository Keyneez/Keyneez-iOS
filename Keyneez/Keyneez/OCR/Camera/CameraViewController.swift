//
//  CameraViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/7/23.
//

import UIKit
import AVFoundation
import SnapKit

final class CameraViewController: NiblessViewController {
  
  // 커스텀 네비게이션 뷰 생성
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: xbutton), .flexibleBox, .iconButton(with: switchButton)]).build()
  
  private lazy var xbutton: UIButton = .init().then {
    $0.setBackgroundImage(UIImage(named: "ic_close")!.imageWithColor(color: .white), for: .normal)
  }
  
  private lazy var switchButton: UIButton = .init(primaryAction: UIAction { [weak self] _ in
    guard let self else { return }
    self.didTouchswitchButton()
  }).then {
    $0.setBackgroundImage(UIImage(named: "ic_switch")!, for: .normal)
  }
  
  private lazy var idCardNotWorkingButton: UIButton = makeAttrStringButton(with: "신분증 인식이 안되나요?").then {
    $0.addAction(UIAction(handler: { [unowned self] _ in
      didTouchidNotWorkingButton()
    }), for: .touchUpInside)
  }
  
  private lazy var cameraButton: UIButton = .init(primaryAction: UIAction { [weak self] _ in
    guard let self else { return }
    self.capturePhoto()
  }).then {
    $0.setBackgroundImage(UIImage(named: "btn_cam"), for: .normal)
  }
  
  private lazy var changeAutoModeButton: UIButton = makeAttrStringButton(with: "자동 인식").then {
    $0.addAction(UIAction(handler: { [unowned self] _ in
      self.didTouchAutoChangeButton()
    }), for: .touchUpInside)
  }
  
  let action = IDCardGuideActions()
  private var customNavigationDelegate = CustomNavigationManager()
  private var previewView: PreviewView = .init()
  private var previewViewMode: PreviewMode = .horizontal
  private var captureMode: CaptureMode = .auto {
    didSet {
      toggleCaptureModeUI()
    }
  }
  
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
  
  private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera, .builtInDualWideCamera],
                                                                             mediaType: .video, position: .unspecified)
  
  private var livePhotoMode: LivePhotoMode = .off
  private var depthDataDeliveryMode: DepthDataDeliveryMode = .off
  private var portraitEffectsMatteDeliveryMode: PortraitEffectsMatteDeliveryMode = .off
  // 이건뭐임?
  private var photoQualityPrioritizationMode: AVCapturePhotoOutput.QualityPrioritization = .balanced
  
  private func didTouchswitchButton() {
    if self.previewViewMode == .vertical { self.previewView.changeToHorizontal() }
    else { self.previewView.changeToVertical() }
    self.previewViewMode.toggle()
    self.previewView.toggleCaptureModeUI(with: self.captureMode, previeMode: self.previewViewMode)
  }
  
  private func didTouchidNotWorkingButton() {
    self.toggleCaptureMode()
    self.previewView.toggleCaptureModeUI(with: self.captureMode, previeMode: self.previewViewMode)
  }
  
  private func didTouchAutoChangeButton() {
    self.toggleCaptureMode()
    self.previewView.toggleCaptureModeUI(with: self.captureMode, previeMode: self.previewViewMode)
  }
  
  private func setCustomNavigationDelegate() -> UIAction {
    return UIAction(handler: { [unowned self] _ in
      customNavigationDelegate.direction = .bottom
      customNavigationDelegate.height = 520
      customNavigationDelegate.heightlimit = 660
      customNavigationDelegate.dimmed = false
      let idInfoEditVC = IDInfoEditableViewController()
      idInfoEditVC.transitioningDelegate = customNavigationDelegate
      idInfoEditVC.modalPresentationStyle = .custom
      self.present(idInfoEditVC, animated: true)
    })
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addsubview()
    setConstraint()
    toggleCaptureModeUI()
    
    previewView.session = session
    checkCameraAuthroizationStatus()
    sessionQueue.async {
      self.configureSession()
    }
  }
  

  private func makeAttrStringButton(with text: String) -> UIButton {
    let button: UIButton = .init()
    let attributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.font(.pretendardMedium, ofSize: 18),
      .foregroundColor: UIColor.gray050,
      .underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    let titleStr = NSAttributedString(string: text, attributes: attributes)
    button.setAttributedTitle(titleStr, for: .normal)
    return button
  }
  
  private func toggleCaptureMode() {
    captureMode.toggle()
  }
  
  private func toggleCaptureModeUI() {
    switch captureMode {
    case .auto:
      cameraButton.isHidden = true
      changeAutoModeButton.isHidden = true
      idCardNotWorkingButton.isHidden = false
    case .manual:
      cameraButton.isHidden = false
      changeAutoModeButton.isHidden = false
      idCardNotWorkingButton.isHidden = true
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
            DispatchQueue.main.async { self.ifNotAuthorized() }
        case .configurationFailed:
            DispatchQueue.main.async { self.ifConfigureFailed() }
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
  
  private func ifConfigureFailed() {
    let alertMsg = "Alert message when something goes wrong during capture session configuration"
    let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
    let alertController = UIAlertController(title: "키니즈", message: message, preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                            style: .cancel,
                                            handler: nil))
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  private func ifNotAuthorized() {
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

// MARK: - UI
extension CameraViewController {
  private func setConstraint() {
    let guide = view.safeAreaLayoutGuide
    previewView.snp.makeConstraints {
      $0.top.bottom.left.right.equalToSuperview()
    }
    
    navigationView.snp.makeConstraints {
      $0.top.left.right.equalTo(guide)
    }
    
    idCardNotWorkingButton.snp.makeConstraints {
      $0.width.equalTo(174)
      $0.height.equalTo(21)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().inset(81)
    }
    
    cameraButton.snp.makeConstraints {
      $0.height.width.equalTo(72)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().inset(89)
    }
    
    changeAutoModeButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().inset(44)
    }
  }
  
  private func addsubview() {
    view.addSubviews(previewView)
    
    [navigationView, idCardNotWorkingButton, cameraButton, changeAutoModeButton].forEach { self.previewView.addSubview($0)}
  }
}
