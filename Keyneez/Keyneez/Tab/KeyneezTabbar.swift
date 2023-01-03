//
//  KeyneezTabbar.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/02.
//

import UIKit
import Then

final class KeyneezTabar: UITabBar {
  
  private struct Constant {
    
  }
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
    let width = self.frame.width
    let height = self.frame.height
    let centerWidth = self.frame.width / 2
    let centerCurveHeigh
    let startPoint = CGPoint(x: 0, y: 0)
    let topRightPoint = CGPoint(x: width, y: 0)
    let bottomRightPoint = CGPoint(x: width, y: height)
    let endPoint = CGPoint(x: 0, y: height)
    let leftLinePoint = CGPoint(x: centerWidth - centerCurveHeight * 2, y: 0)
    let leftCurveToPoint = CGPoint(x: centerWidth, y: centerCurveHeight)
    let leftCurveControlPoint1 = CGPoint(x: centerWidth - 30, y: 0)
    let leftCurveControlPoint2 = CGPoint(x: centerWidth - 35, y: centerCurveHeight)
    let rightCurveToPoint = CGPoint(x: centerWidth + centerCurveHeight * 2, y: 0)
    let rightCurveControlPoint1 = CGPoint(x: centerWidth + 35, y: centerCurveHeight)
    let rightCurveControlPoint2 = CGPoint(x: centerWidth + 30, y: 0)

    let path = UIBezierPath().then {
      $0.move(to: startPoint) // start top left
      $0.addLine(to: leftLinePoint)
      $0.addCurve(to: leftCurveToPoint, controlPoint1: leftCurveControlPoint1, controlPoint2: leftCurveControlPoint2)
      $0.addCurve(to: rightCurveToPoint, controlPoint1: rightCurveControlPoint1, controlPoint2: rightCurveControlPoint2)
      $0.addLine(to: topRightPoint)
      $0.addLine(to: bottomRightPoint)
      $0.addLine(to: endPoint)
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
