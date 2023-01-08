//
//  UISegmentedControl+Extension.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/09.
//

import UIKit

extension UISegmentedControl {
  func removeBorder() {
    self.selectedSegmentTintColor = .clear
    self.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
    self.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
  }
  func setNormalFont(font: UIFont, fontColor: UIColor) {
    self.setTitleTextAttributes([
      NSAttributedString.Key.foregroundColor: fontColor,
      NSAttributedString.Key.font: font
    ], for: .normal)
  }
  func setSelectedFont(font: UIFont, fontColor: UIColor) {
    self.setTitleTextAttributes([
      NSAttributedString.Key.foregroundColor: fontColor,
      NSAttributedString.Key.font: font
    ], for: .selected)
  }
}
