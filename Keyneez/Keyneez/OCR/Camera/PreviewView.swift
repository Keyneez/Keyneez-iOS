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
}
