//
//  CameraViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/7/23.
//

import UIKit
import Foundation
import SnapKit
import AVFoundation
import MLKitTextRecognitionKorean
import MLKitTextRecognition
import MLKit
import MLImage
import CoreVideo
import Photos

private struct Constant {
  static let bottomsheetHeight: CGFloat = 520
  static let bottomsheetHeightWithKeyboard: CGFloat = 660
  static let xbuttonName = "ic_close"
  static let switchButtonName = "ic_switch"
  static let videoDataOutputQueueLabel = "VideoDataOutputQueue"
  static let sessionQueueLabel = "textrecognizer.SessionQueue"
}

final class CameraViewController: NiblessViewController {
  
  // 커스텀 네비게이션 뷰 생성
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: xbutton), .flexibleBox, .iconButton(with: switchButton)]).build()
  
  private lazy var xbutton: UIButton = .init().then {
    $0.setBackgroundImage(UIImage(named: Constant.xbuttonName)!.imageWithColor(color: .white), for: .normal)
    $0.addAction(actions.didTouchBackButton(), for: .touchUpInside)
  }
  
  private lazy var switchButton: UIButton = .init(primaryAction: UIAction { [weak self] _ in
    guard let self else { return }
    self.didTouchswitchButton()
  }).then {
    $0.setBackgroundImage(UIImage(named: Constant.switchButtonName)!, for: .normal)
  }
  
  private lazy var idCardNotWorkingButton: UIButton = makeAttrStringButton(with: "신분증 인식이 안되나요?").then {
    $0.addAction(UIAction(handler: { [unowned self] _ in
      didTouchidNotWorkingButton()
    }), for: .touchUpInside)
  }
  
  private lazy var cameraButton: UIButton =
    .init(primaryAction: didTouchCaptureButton())
    .then {
      $0.setBackgroundImage(UIImage(named: "btn_cam"), for: .normal)
    }
  
  private lazy var changeAutoModeButton: UIButton = makeAttrStringButton(with: "자동 인식").then {
    $0.addAction(UIAction(handler: { [unowned self] _ in
      self.didTouchAutoChangeButton()
    }), for: .touchUpInside)
  }
  
  private var customNavigationDelegate = CustomNavigationManager()
  private var previewView: PreviewView = .init()
  private var previewViewMode: PreviewMode = .horizontal
  private var captureMode: CaptureMode = .auto {
    didSet {
      toggleCaptureModeUI()
    }
  }
  
  var windowOrientation: UIInterfaceOrientation {
    return view.window?.windowScene?.interfaceOrientation ?? .unknown
  }
  
  private func didTouchCaptureButton() -> UIAction {
    return UIAction { [weak self] _ in
      guard let self else { return }
      self.camera.capturePhoto(videoPreviewLayerOrientation: self.previewView.videoPreviewLayer.connection?.videoOrientation) { text, image in
        self.actions.OCRConfirmed(with: self.customNavigationDelegate, height: 520, heightIncludeKeyboard: 690, text: text, image: image)
      }
    }
  }
  
  private func didTouchswitchButton() {
    if self.previewViewMode == .vertical {
      self.previewView.changeToHorizontal()
    } else { self.previewView.changeToVertical() }
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
  
  var camera: Camera
  var ocrService: OCRService
  
  override init() {
    self.camera = Camera()
    self.ocrService = OCRService()
    super.init()
  }
  
  private lazy var actions: CameraViewActionables = CameraViewActions(viewcontroller: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addsubview()
    setConstraint()
    toggleCaptureModeUI()
    previewView.session = camera.session
    
    camera.configure { [weak self] in
      guard let self else {return}
    }
    self.setVideoOrientation()
    setUpCaptureSessionOutput()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    camera.checkSetupResult()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    camera.resume(sessionNotRunningcompletion: nil, sessionRunningCompletion: nil)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.camera.session.stopRunning()
  }
  
}

// MARK: - Private

extension CameraViewController {
  
  private func setVideoOrientation() {
    var initialVideoOrientation: AVCaptureVideoOrientation = .portrait
    if self.windowOrientation != .unknown {
      if let videoOrientation = AVCaptureVideoOrientation(interfaceOrientation: self.windowOrientation) {
        initialVideoOrientation = videoOrientation
      }
    }
    
    self.previewView.videoPreviewLayer.connection?.videoOrientation = initialVideoOrientation
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
    [navigationView, idCardNotWorkingButton, cameraButton, changeAutoModeButton]
      .forEach { self.previewView.addSubview($0) }
  }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraViewController {
  func setUpCaptureSessionOutput() {
    weak var weakSelf = self
    weakSelf?.camera.sessionQueue.async {
      guard let strongSelf = weakSelf else {
        print("Self is nil!")
        return
      }
      strongSelf.camera.session.beginConfiguration()
      // When performing latency tests to determine ideal capture settings,
      // run the app in 'release' mode to get accurate performance metrics
      
      let output = AVCaptureVideoDataOutput()
      output.videoSettings = [
        (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA
      ]
      output.alwaysDiscardsLateVideoFrames = true
      let outputQueue = DispatchQueue(label: Constant.videoDataOutputQueueLabel)
      output.setSampleBufferDelegate(strongSelf, queue: outputQueue)
      guard strongSelf.camera.session.canAddOutput(output) else {
        print("Failed to add capture session output.")
        return
      }
      strongSelf.camera.session.addOutput(output)
      strongSelf.camera.session.commitConfiguration()
    }
  }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  
  func captureOutput(
    _ output: AVCaptureOutput,
    didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    
    // 수동모드일때 OFF
    if captureMode == .manual { return }
    
    //버퍼처리를 할 Semaphore
    ocrService.semaphore.wait()

    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      print("Failed to get image buffer from sample buffer.")
      return
    }
    
    camera.lastFrame = sampleBuffer
    let ciimage = convert(sampleBuffer)
    let tempImage = UIImage(ciImage: ciimage)
    
    let deviceScreen = UIScreen.main.bounds.size
    let newImage = UIImage(cgImage: resizeImage(image: tempImage, size: tempImage.size))
    let newx = regionOfInterestSize.origin.x / deviceScreen.height * tempImage.size.height
    let newy = regionOfInterestSize.origin.y / deviceScreen.height * tempImage.size.height
    let newHeight = regionOfInterestSize.height / deviceScreen.height * tempImage.size.height
    let newWidth = newHeight * regionOfInterestSize.width / regionOfInterestSize.height
    
    let cropped = newImage.cgImage?.cropping(to: CGRect(x: tempImage.size.width / 2 - newWidth / 2, y: newy, width: newHeight * regionOfInterestSize.width / regionOfInterestSize.height, height: newHeight))
    
    let newCropped = UIImage(cgImage: cropped!, scale: newImage.scale, orientation: newImage.imageOrientation)
    
    let visionImage = VisionImage(image: newCropped)
    let orientation = UIUtilities.imageOrientation(
      fromDevicePosition: .front
    )
    visionImage.orientation = orientation
    
    guard let inputImage = MLImage(sampleBuffer: sampleBuffer) else {
      print("Failed to create MLImage from sample buffer.")
      return
    }
    inputImage.orientation = orientation
    
    let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
    let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
    ocrService.recognizeText(in: visionImage, with: newCropped, width: imageWidth, height: imageHeight) { [weak self] text, image in
      guard let self else {return}
      self.processWhenSuccessOCRAuto(image: image, text: text, name: 4)
    }
  }
  
  func processWhenSuccessOCRAuto(image: UIImage, text: [String],  name: Int) {
    // Text Process
    DispatchQueue.main.async {
      self.actions.OCRConfirmed(with: self.customNavigationDelegate, height: 520, heightIncludeKeyboard: 690, text: text, image: image)
      self.saveImage(image: image, name: 4)
      self.camera.session.stopRunning()
    }
  }
}

// MARK: - Save, Resize, BufferToCIImage

extension CameraViewController {
  
  func saveImage(image: UIImage, name: Int) -> Bool {
          guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
              return false
          }
          guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
              return false
          }
          do {
              try data.write(to: directory.appendingPathComponent("profile\(name).png")!)
              return true
          } catch {
              print(error.localizedDescription)
              return false
          }
      }
  
  private func resizeImage(image: UIImage, size: CGSize) -> CGImage {
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
  
  private func convert(_ sampleBuffer: CMSampleBuffer) -> CIImage {
    let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
    CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
    
    let baseAddress = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0)!
    let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
    let width = CVPixelBufferGetWidth(pixelBuffer)
    let height = CVPixelBufferGetHeight(pixelBuffer)
    
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    let newContext = CGContext(data: baseAddress,
                               width: width,
                               height: height,
                               bitsPerComponent: 8,
                               bytesPerRow: bytesPerRow,
                               space: colorSpace,
                               bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
    
    let imageRef = newContext.makeImage()!
    CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
    
    var output = CIImage(cgImage: imageRef)
    
    var transform = output.orientationTransform(forExifOrientation: 6) // UIImageOrientation.right
    output = output.transformed(by: transform)
    
    let ratio = output.extent.size.width / output.extent.size.width
    transform = output.orientationTransform(forExifOrientation: 1)
    transform = transform.scaledBy(x: ratio, y: ratio)
    output = output.transformed(by: transform)
    
    transform = output.orientationTransform(forExifOrientation: 1)
    transform = transform.translatedBy(x: 0, y: -(output.extent.size.height - output.extent.size.height) / 2)
    output = output.transformed(by: transform)
    
    return output.cropped(to: CGRect(origin: CGPoint.zero, size: output.extent.size))
  }
  
}
