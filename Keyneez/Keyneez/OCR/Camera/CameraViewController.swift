//
//  CameraViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/7/23.
//

import UIKit
import AVFoundation
import SnapKit

private struct Constant {
  static let bottomsheetHeight: CGFloat = 520
  static let bottomsheetHeightWithKeyboard: CGFloat = 660
  static let xbuttonName = "ic_close"
  static let switchButtonName = "ic_switch"
}

final class CameraViewController: NiblessViewController {
  
  // 커스텀 네비게이션 뷰 생성
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: xbutton), .flexibleBox, .iconButton(with: switchButton)]).build()
  
  private lazy var xbutton: UIButton = .init().then {
    $0.setBackgroundImage(UIImage(named: Constant.xbuttonName)!.imageWithColor(color: .white), for: .normal)
    $0.addAction(didTouchBackButton(), for: .touchUpInside)
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
  
  private lazy var cameraButton: UIButton = .init(primaryAction: OCRConfirmed()).then {
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
  
  var windowOrientation: UIInterfaceOrientation {
    return view.window?.windowScene?.interfaceOrientation ?? .unknown
  }
  
  private func didTouchCaptureButton() -> UIAction {
    return UIAction { [weak self] _ in
      guard let self else { return }
      self.camera.capturePhoto(videoPreviewLayerOrientation: self.previewView.videoPreviewLayer.connection?.videoOrientation)
    }
  }
  
  private func didTouchBackButton() -> UIAction {
    return UIAction(handler: { _ in
      self.dismiss(animated: true)
    })
  }
  
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
  
  private func OCRConfirmed() -> UIAction {
    return UIAction(handler: { [unowned self] _ in
      customNavigationDelegate.direction = .bottom
      customNavigationDelegate.height = Constant.bottomsheetHeight
      customNavigationDelegate.heightIncludeKeyboard = Constant.bottomsheetHeightWithKeyboard
      customNavigationDelegate.dimmed = false
      let idInfoEditVC = IDInfoEditableViewController()
      idInfoEditVC.transitioningDelegate = customNavigationDelegate
      idInfoEditVC.modalPresentationStyle = .custom
      self.present(idInfoEditVC, animated: true)
    })
  }
  
  private var camera: Camera = .init()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addsubview()
    setConstraint()
    toggleCaptureModeUI()
    previewView.session = camera.session
    camera.configure { [weak self] in
      guard let self else {return}
      self.setVideoOrientation()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    camera.checkSetupResult()
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
      .forEach { self.previewView.addSubview($0)}
  }
}
