//
//  UILabel+Extension.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/12.
//

import UIKit

extension UILabel {
  func setLineSpacing(spacing: CGFloat) {
    guard let text = text else { return }
    
    let attributeString = NSMutableAttributedString(string: text)
    let style = NSMutableParagraphStyle()
    style.lineSpacing = spacing
    attributeString.addAttribute(.paragraphStyle,
                                 value: style,
                                 range: NSRange(location: 0, length: attributeString.length))
    attributedText = attributeString
  }
}
