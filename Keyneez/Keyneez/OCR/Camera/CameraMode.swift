//
//  CameraMode.swift
//  Keyneez
//
//  Created by Jung peter on 1/9/23.
//

import Foundation

enum SessionSetupResult {
  case success
  case notAuthorized
  case configurationFailed
}

enum LivePhotoMode {
  case on
  case off
}

enum DepthDataDeliveryMode {
  case on
  case off
}

enum PortraitEffectsMatteDeliveryMode {
  case on
  case off
}

enum PreviewMode {
  case vertical
  case horizontal
  
  mutating func toggle() {
    switch self {
    case .vertical:
      self = .horizontal
    case .horizontal:
      self = .vertical
    }
  }
}

enum CaptureMode {
  case auto
  case manual
  
  mutating func toggle() {
    switch self {
    case .auto:
      self = .manual
    case .manual:
      self = .auto
    }
  }
}
