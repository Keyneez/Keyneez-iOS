//
//  AddSubViews.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/04.
//

import UIKit

extension UIView {
  func addSubviews(_ views: UIView...) {
    views.forEach { self.addSubview($0) }
  }
}
