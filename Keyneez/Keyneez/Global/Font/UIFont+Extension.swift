//
//  FontLiterals.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/02.
//

import UIKit

//    label.font = UIFont.font(.pretendardMedium, ofSize: 24)

enum FontName: String {
  case pretendardBold = "Pretendard-Bold"
  case pretendardSemiBold = "Pretendard-SemiBold"
  case pretendardMedium = "Pretendard-Medium"
}

extension UIFont {
  static func font(_ style: FontName, ofSize size: CGFloat) -> UIFont {
    return UIFont(name: style.rawValue, size: size)!
  }
}
  
