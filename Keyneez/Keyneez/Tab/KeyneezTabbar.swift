//
//  KeyneezTabbar.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/02.
//

import UIKit
import Then

final class KeyneezTabar: UITabBar {
  private var shapeLayer: CALayer?

  private func setShapeLayer() -> CAShapeLayer {
    let shapeLayer = CAShapeLayer().then {
      $0.path = createPath()
      $0.fillColor = UIColor.gray050.cgColor
      $0.strokeColor = UIColor.gray100.cgColor
      $0.lineWidth = 1.0
      $0.shadowOffset = CGSize(width:0, height:0)
      $0.shadowRadius = 10
      $0.shadowColor = UIColor.gray100.cgColor
      $0.shadowOpacity = 0.3
    }
    return shapeLayer
  }
  
  private func addShape() {
    let shapeLayer = setShapeLayer()
    let oldShapeLayer = (self.shapeLayer != nil) ?
    self.layer.replaceSublayer(self.shapeLayer!, with: shapeLayer) :
    self.layer.insertSublayer(shapeLayer, at: 0)
    self.shapeLayer = shapeLayer
  }

  override func draw(_ rect: CGRect) {
    self.addShape()
  }

  private func createPath() -> CGPath {
    let height: CGFloat = 20.0
    let centerWidth = self.frame.width / 2
    let path = UIBezierPath().then {
      $0.move(to: CGPoint(x: 0, y: 0)) // start top left
      $0.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0))
      $0.addCurve(to: CGPoint(x: centerWidth, y: height),
                    controlPoint1: CGPoint(x: (centerWidth - 30), y: 0),
                  controlPoint2: CGPoint(x: centerWidth - 35, y: height))
      $0.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                    controlPoint1: CGPoint(x: centerWidth + 35, y: height),
                  controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
      $0.addLine(to: CGPoint(x: self.frame.width, y: 0))
      $0.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
      $0.addLine(to: CGPoint(x: 0, y: self.frame.height))
      $0.close()
    }
    return path.cgPath
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
    for member in subviews.reversed() {
      let subPoint = member.convert(point, from: self)
      guard let result = member.hitTest(subPoint, with: event) else { continue }
      return result
    }
    return nil
  }
}
