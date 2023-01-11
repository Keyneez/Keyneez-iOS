//
//  CustomNavigationAnimator.swift
//  Keyneez
//
//  Created by Jung peter on 1/6/23.
//

import Foundation
import UIKit

final class CustomNavigationAnimator: NSObject {
  
  private let direction: PresentationDirection
  private let duration = 0.3
  private let isPresentation: Bool
  
  init(direction: PresentationDirection, isPresentation: Bool) {
    self.direction = direction
    self.isPresentation = isPresentation
    super.init()
  }
  
}

extension CustomNavigationAnimator: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
    
    guard let controller = transitionContext.viewController(forKey: key)
        else { return }
    
    if isPresentation {
      transitionContext.containerView.addSubview(controller.view)
    }
    let presentedFrame = transitionContext.finalFrame(for: controller)
    var dismissFrame = presentedFrame
    
    switch direction {
    case .left:
      dismissFrame.origin.x = -presentedFrame.width
    case .right:
      dismissFrame.origin.x = transitionContext.containerView.frame.size.width
    case .bottom:
      dismissFrame.origin.y = transitionContext.containerView.frame.size.height
    case .top:
      dismissFrame.origin.y = -presentedFrame.height
    }
    
    let initialFrame = isPresentation ? dismissFrame : presentedFrame
    let finalFrame = isPresentation ? presentedFrame : dismissFrame
    
    let animationDuration = transitionDuration(using: transitionContext)
    controller.view.frame = initialFrame
    UIView.animate(
        withDuration: animationDuration,
        animations: {
          controller.view.frame = finalFrame
      }, completion: { ended in
        if !self.isPresentation {
          controller.view.removeFromSuperview()
        }
        transitionContext.completeTransition(ended)
      })

  }
}
