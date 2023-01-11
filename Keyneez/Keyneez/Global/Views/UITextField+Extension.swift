//
//  UIView+Extension.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/02.
//

import UIKit
import Then

extension UITextField {
  
  fileprivate class Constant {
    static let textFieldHeight: CGFloat = 48
    static let padding: CGFloat = 24
  }
  
  func underlineStyle(textColor: UIColor = .gray900,
                      borderColor: UIColor = .gray400,
                      padding: CGFloat = Constant.padding,
                      height: CGFloat = Constant.textFieldHeight) {
    self.borderStyle = .none
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0,
                              y: height,
                              width: UIScreen.main.bounds.width - (2 * padding),
                              height: 1)
    bottomLine.backgroundColor = borderColor.cgColor
    self.layer.addSublayer(bottomLine)
    self.textColor = textColor
  }
  
  func setPlaceholderColorAndFont(_ placeholderColor: UIColor, font: UIFont) {
    attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor, .font: font].compactMapValues{$0})
  }
  
}
