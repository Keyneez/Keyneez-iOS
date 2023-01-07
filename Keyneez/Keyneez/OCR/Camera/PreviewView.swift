//
//  PreviewView.swift
//  Keyneez
//
//  Created by Jung peter on 1/7/23.
//

import UIKit
import AVFoundation

final class PreviewView: UIView {
  
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
  
  private var maskLayer = CAShapeLayer()
  private var regionOfInterestOutline = CAShapeLayer()
  private lazy var regionOfInterest = CGRect(x: CGFloat((UIScreen.main.bounds.size.width - 327) / 2), y: 312, width: 327, height: 200)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    commonInit()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
    path.append(UIBezierPath(roundedRect: regionOfInterest, cornerRadius: 12))
    path.usesEvenOddFillRule = true
    maskLayer.path = path.cgPath
    regionOfInterestOutline.path = CGPath(roundedRect: regionOfInterest, cornerWidth: 12, cornerHeight: 12, transform: nil)
  }
  
  func commonInit() {
    
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
  
}
