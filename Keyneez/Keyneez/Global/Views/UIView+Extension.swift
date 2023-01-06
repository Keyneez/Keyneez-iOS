//
//  UIViews+Extension.swift
//  Keyneez
//
//  Created by Jung peter on 1/6/23.
//

import UIKit

extension UIView {
  func setRound(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
}
