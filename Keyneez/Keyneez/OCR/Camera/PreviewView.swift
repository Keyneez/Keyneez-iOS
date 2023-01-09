//
//  PreviewView.swift
//  Keyneez
//
//  Created by Jung peter on 1/7/23.
//

import UIKit
import AVFoundation

private struct Constant {
  static let cardLargeSize: CGFloat = 327
  static let cardSmallSize: CGFloat = 200
  static let cornerRadius: CGFloat = 12
  static let verticalTitleGap: CGFloat = 32
  static let horizontalTitleGap: CGFloat = 40
  static let verticalCardGap: CGFloat = 251
  static let horizontalCardGap: CGFloat = 312
  static let autoDescription = "학생증/청소년증을\n평평하고 그늘진 곳에 놓아주세요"
  static let manualDescription = "준비가 끝나면 촬영 버튼을 눌러주세요"
  static let guideTitle = "신분증 앞면을\n사각형 안에 맞춰주세요."
}

final class PreviewView: NiblessView {
  
  var videoPreviewLayer: AVCaptureVideoPreviewLayer {
      guard let layer = layer as? AVCaptureVideoPreviewLayer else {
          fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
      }
      return layer
  }
  
  var session: AVCaptureSession? {
      get {
          return videoPreviewLayer.session
      }
      set {
          videoPreviewLayer.session = newValue
      }
  }
  
  override class var layerClass: AnyClass {
      return AVCaptureVideoPreviewLayer.self
  }
  
  private lazy var guideTitleLabel: UILabel = .init().then {
    $0.text = Constant.guideTitle
    $0.font = .font(.pretendardBold, ofSize: 24)
    $0.textColor = .gray050
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }
  
  private lazy var guideDescriptionLabel: UILabel = .init().then {
    $0.text = Constant.autoDescription
    $0.textColor = .gray500
    $0.font = .font(.pretendardMedium, ofSize: 18)
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }
  
  private var maskLayer = CAShapeLayer()
  private var regionOfInterestOutline = CAShapeLayer()
  private lazy var regionOfInterestView: UIView = .init()
  private lazy var regionOfInterest = CGRect.init()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    addsubview()
    setContstraint()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.regionOfInterest = self.regionOfInterestView.frame
    
    let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
    path.append(UIBezierPath(roundedRect: regionOfInterest, cornerRadius: Constant.cornerRadius))
    path.usesEvenOddFillRule = true
    maskLayer.path = path.cgPath
    regionOfInterestOutline.path = CGPath(roundedRect: regionOfInterest, cornerWidth: Constant.cornerRadius, cornerHeight: Constant.cornerRadius, transform: nil)
    
  }
  
  
  internal func changeToVertical() {
      regionOfInterestView.snp.remakeConstraints {
        $0.centerX.equalToSuperview()
        $0.height.equalTo(Constant.cardLargeSize)
        $0.width.equalTo(Constant.cardSmallSize)
        $0.top.equalToSuperview().inset(Constant.verticalCardGap)
      }
      
      guideTitleLabel.snp.remakeConstraints {
        $0.centerX.equalToSuperview()
        $0.bottom.equalTo(regionOfInterestView.snp.top).offset(-Constant.verticalTitleGap)
      }
      
      guideDescriptionLabel.snp.remakeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalTo(regionOfInterestView.snp.bottom).offset(Constant.verticalTitleGap)
      }
   
  }
  
  internal func toggleCaptureModeUI(with mode: CaptureMode, previeMode: PreviewMode) {
    switch previeMode {
    case .vertical:
      didCaptureModeChangeWhenVertical(with: mode)
    case .horizontal:
      didCaptureModeChangeWhenHorizontal(with: mode)
    }
  }
  
  internal func changeToHorizontal() {
    regionOfInterestView.snp.remakeConstraints {
      $0.centerX.equalToSuperview()
      $0.height.equalTo(Constant.cardSmallSize)
      $0.width.equalTo(Constant.cardLargeSize)
      $0.top.equalToSuperview().inset(Constant.horizontalCardGap)
    }
    
    guideTitleLabel.snp.remakeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(regionOfInterestView.snp.top).offset(-Constant.horizontalTitleGap)
    }
    
    guideDescriptionLabel.snp.remakeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(regionOfInterestView.snp.bottom).offset(Constant.horizontalTitleGap)
    }
  
  }
  
}

// MARK: - Private

extension PreviewView {
  
  private func commonInit() {
    
    videoPreviewLayer.videoGravity = .resizeAspectFill
    
    maskLayer.fillRule = .evenOdd
    maskLayer.fillColor = UIColor.black.cgColor
    maskLayer.opacity = 0.8
    layer.addSublayer(maskLayer)
    
    regionOfInterestOutline.lineWidth = 3
    regionOfInterestOutline.path = UIBezierPath(roundedRect: regionOfInterest, cornerRadius: Constant.cornerRadius).cgPath
    regionOfInterestOutline.fillColor = UIColor.clear.cgColor
    regionOfInterestOutline.strokeColor = UIColor.white.cgColor
    layer.addSublayer(regionOfInterestOutline)
  }
  
  private func didCaptureModeChangeWhenHorizontal(with mode: CaptureMode) {
    switch mode {
    case .manual:
      guideDescriptionLabel.text = Constant.manualDescription
    case .auto:
      guideDescriptionLabel.text =  Constant.autoDescription
    }
  }
  
  private func didCaptureModeChangeWhenVertical(with mode: CaptureMode) {
    switch mode {
    case .manual:
      guideDescriptionLabel.text = nil
    case .auto:
      guideDescriptionLabel.text =  Constant.autoDescription
    }
  }
  
  private func addsubview() {
    [regionOfInterestView, guideTitleLabel, guideDescriptionLabel].forEach { self.addSubview($0) }
  }
  
  private func setContstraint() {
    
    regionOfInterestView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.height.equalTo(Constant.cardSmallSize)
      $0.width.equalTo(Constant.cardLargeSize)
      $0.top.equalToSuperview().inset(Constant.horizontalCardGap)
    }
    
    guideTitleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(regionOfInterestView.snp.top).offset(-Constant.horizontalTitleGap)
    }
    
    guideDescriptionLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(regionOfInterestView.snp.bottom).offset(Constant.horizontalTitleGap)
    }
  }
}
