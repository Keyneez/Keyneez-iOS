//
//  PreviewView.swift
//  Keyneez
//
//  Created by Jung peter on 1/7/23.
//

import UIKit
import AVFoundation

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
    $0.text = "신분증 앞면을\n사각형 안에 맞춰주세요."
    $0.font = .font(.pretendardBold, ofSize: 24)
    $0.textColor = .gray050
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }
  
  private lazy var guideDescriptionLabel: UILabel = .init().then {
    $0.text = "학생증/청소년증을\n평평하고 그늘진 곳에 놓아주세요"
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
    path.append(UIBezierPath(roundedRect: regionOfInterest, cornerRadius: 12))
    path.usesEvenOddFillRule = true
    maskLayer.path = path.cgPath
    regionOfInterestOutline.path = CGPath(roundedRect: regionOfInterest, cornerWidth: 12, cornerHeight: 12, transform: nil)
    
  }
  
  
  internal func changeToVertical() {
      regionOfInterestView.snp.remakeConstraints {
        $0.centerX.equalToSuperview()
        $0.height.equalTo(327)
        $0.width.equalTo(200)
        $0.top.equalToSuperview().inset(251)
      }
      
      guideTitleLabel.snp.remakeConstraints {
        $0.centerX.equalToSuperview()
        $0.bottom.equalTo(regionOfInterestView.snp.top).offset(-32)
      }
      
      guideDescriptionLabel.snp.remakeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalTo(regionOfInterestView.snp.bottom).offset(32)
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
      $0.height.equalTo(200)
      $0.width.equalTo(327)
      $0.top.equalToSuperview().inset(312)
    }
    
    guideTitleLabel.snp.remakeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(regionOfInterestView.snp.top).offset(-40)
    }
    
    guideDescriptionLabel.snp.remakeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(regionOfInterestView.snp.bottom).offset(40)
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
    regionOfInterestOutline.path = UIBezierPath(roundedRect: regionOfInterest, cornerRadius: 12).cgPath
    regionOfInterestOutline.fillColor = UIColor.clear.cgColor
    regionOfInterestOutline.strokeColor = UIColor.white.cgColor
    layer.addSublayer(regionOfInterestOutline)
  }
  
  private func didCaptureModeChangeWhenHorizontal(with mode: CaptureMode) {
    switch mode {
    case .manual:
      guideDescriptionLabel.text = "준비가 끝나면 촬영 버튼을 눌러주세요"
    case .auto:
      guideDescriptionLabel.text =  "학생증/청소년증을\n평평하고 그늘진 곳에 놓아주세요"
    }
  }
  
  private func didCaptureModeChangeWhenVertical(with mode: CaptureMode) {
    switch mode {
    case .manual:
      guideDescriptionLabel.text = nil
    case .auto:
      guideDescriptionLabel.text =  "학생증/청소년증을\n평평하고 그늘진 곳에 놓아주세요"
    }
  }
  
  private func addsubview() {
    [regionOfInterestView, guideTitleLabel, guideDescriptionLabel].forEach { self.addSubview($0) }
  }
  
  private func setContstraint() {
    
    regionOfInterestView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.height.equalTo(200)
      $0.width.equalTo(327)
      $0.top.equalToSuperview().inset(312)
    }
    
    guideTitleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(regionOfInterestView.snp.top).offset(-40)
    }
    
    guideDescriptionLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(regionOfInterestView.snp.bottom).offset(40)
    }
  }
}
