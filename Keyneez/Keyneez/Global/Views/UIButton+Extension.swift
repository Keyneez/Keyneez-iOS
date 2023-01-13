//
//  UIButton+Extension.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/02.
//

import Foundation
import UIKit

extension UIButton {

  //    testButton.keyneezButtonStyle(style: .whiteUnact, title: "로그인")

  enum KeyneezButtonStyle {
    case whiteAct
    case whiteUnact
    case blackAct
    case blackUnact
    case btnM


    var backgroundColor: UIColor? {
      switch self {
      case .whiteAct:
        return .gray050
      case .whiteUnact:
        return .gray050
      case.blackAct:
        return .gray900
      case .blackUnact:
        return .gray300
      case .btnM:
        return .gray050

      }
  
    }

    var foregroundColor: UIColor? {
      switch self {
      case .whiteAct:
        return .gray900
      case .whiteUnact:
        return .gray300
      case .blackAct:
        return .gray050
      case .blackUnact:
        return .gray050
      case .btnM:
        return .gray800
 
      }
    }
  }

  func keyneezButtonStyle(style: KeyneezButtonStyle, title: String, action: UIAction? = nil) {
     self.setTitle(title, for: .normal)
     self.titleLabel?.font = UIFont.font(.pretendardBold, ofSize: 16)
     self.layer.cornerRadius = 4
     self.backgroundColor = style.backgroundColor
     self.setTitleColor(style.foregroundColor, for: .normal)
    borderWidthAndBorderColor(with: style)
    guard let action = action else {return}
    self.addAction(action, for: .touchUpInside)
  }
  
  private func borderWidthAndBorderColor(with style: KeyneezButtonStyle) {
    switch style {
    case .whiteAct:
      self.layer.borderWidth = 1
      self.layer.borderColor = UIColor.gray900.cgColor
    case .whiteUnact:
      self.layer.borderWidth = 1
      self.layer.borderColor = UIColor.gray300.cgColor
    default:
      return
    }
  }
}
