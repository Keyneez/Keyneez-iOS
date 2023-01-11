//
//  LoadingView.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/04.
//

import UIKit

// 사용법
// @objc func taped(_ sender: UITapGestureRecognizer) {
//    LoadingView.show()
//
//    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//        LoadingView.hide()
//    }
// }

class LoadingView: NSObject {
  
  private static let sharedInstance = LoadingView()
  private var popupView = UIImageView()
  private var backgroundView = UIView()
  
  class func show() {
    let backgroundView = UIView()
    let popupView = UIImageView(frame: CGRect(x: 0, y: 0, width: 56, height: 88))
    popupView.backgroundColor = .gray050
    popupView.animationImages = animationImageArray()
    popupView.animationDuration = 0.5
    popupView.animationRepeatCount = 0
    
    if let window = UIApplication.shared.windows.first(where: \.isKeyWindow) {
      window.addSubview(backgroundView)
      window.addSubview(popupView)
      
      backgroundView.backgroundColor = .gray050
      backgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.maxX, height: window.frame.maxY)
      
      popupView.center = window.center
      popupView.startAnimating()
      
      sharedInstance.backgroundView.removeFromSuperview()
      sharedInstance.popupView.removeFromSuperview()
      sharedInstance.backgroundView = backgroundView
      sharedInstance.popupView = popupView
    }
  }
  
  class func hide() {
    sharedInstance.popupView.stopAnimating()
    sharedInstance.backgroundView.removeFromSuperview()
    sharedInstance.popupView.removeFromSuperview()
    
  }
}

private func animationImageArray() -> [UIImage] {
  var animationArray: [UIImage] = []
  animationArray.append(UIImage(named: "Loading1")!)
  animationArray.append(UIImage(named: "Loading2")!)
  animationArray.append(UIImage(named: "Loading3")!)
  return animationArray
}
