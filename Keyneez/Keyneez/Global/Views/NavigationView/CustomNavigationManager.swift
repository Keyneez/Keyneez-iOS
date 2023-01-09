//
//  CustomNavigationManager.swift
//  Keyneez
//
//  Created by Jung peter on 1/6/23.
//

import UIKit

// Presentataion Direction을 통해서 어디서 올라오거나 나오는 present style을 만들수 있다.
enum PresentationDirection {
  case left
  case right
  case top
  case bottom
}

// UIViewControllerTransitioningDelegate을 채택하고 있기 떄문에 VC에서 delegate을 위임할때 self가
// 아닌 이 class로 주면 된다.
class CustomNavigationManager: NSObject, UIViewControllerTransitioningDelegate {
  
  var direction: PresentationDirection = .left
  var height: CGFloat = 300
  var heightIncludeKeyboard: CGFloat = UIScreen.main.bounds.size.height
  var dimmed: Bool = true
  
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let presentationController = CustomNavigationPresentationController(presentedViewController: presented, presenting: presenting, direction: direction, height: height, dimmed: dimmed, heightIncludeKeyboard: heightIncludeKeyboard)
    return presentationController
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CustomNavigationAnimator(direction: direction, isPresentation: true)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CustomNavigationAnimator(direction: direction, isPresentation: false)
  }
  
}
