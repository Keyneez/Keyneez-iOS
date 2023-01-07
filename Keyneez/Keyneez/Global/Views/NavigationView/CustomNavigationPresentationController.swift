//
//  CustomNavigationPresentationController.swift
//  Keyneez
//
//  Created by Jung peter on 1/6/23.
//

import Foundation
import UIKit

final class CustomNavigationPresentationController: UIPresentationController {
  
  private var direction: PresentationDirection
  private var height: CGFloat
  private var dimmingView: UIView!
  private var dragIndicator: UIView!
  private var dragIndicatorView: UIView!
  
  init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: PresentationDirection, height: CGFloat) {
    self.direction = direction
    self.height = height
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    setupDimmingView()
    setupDragIndicatorView()
  }
  
  // container layout 정하기
  override func containerViewWillLayoutSubviews() {
    switch direction {
    case .left:
      presentedView?.frame = frameOfPresentedViewInContainerView
    case .right:
      presentedView?.frame = frameOfPresentedViewInContainerView
    case .top:
      presentedView?.frame = frameOfPresentedViewInContainerView
    case .bottom:
      presentedView?.frame = frameOfPresentedViewInContainerView
//      presentedView?.clipsToBounds = true
//      presentedView?.layer.cornerRadius = 22
//      presentedView?.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
  }
  
  // containerview 크기 정하기
  override var frameOfPresentedViewInContainerView: CGRect {
    var frame: CGRect = .zero
    frame.size = size(forChildContentContainer: presentedViewController,
                      withParentContainerSize: containerView!.bounds.size)
    switch direction {
    case .bottom:
      var presentedFrame: CGRect = .zero
      presentedFrame.origin.y = frame.size.height - height
      presentedFrame.size = CGSize(width: frame.width, height: height)
      return presentedFrame
    default:
      return frame
    }
  }
  
  override func presentationTransitionWillBegin() {
    guard let dimmingView = dimmingView else {
      return
    }
    containerView?.insertSubview(dimmingView, at: 0)
    
    dimmingView.snp.makeConstraints {
      $0.top.bottom.left.right.equalToSuperview()
    }
    
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 1.0
      return
    }
    
    coordinator.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = 1.0
    })
  }
  
  override func dismissalTransitionWillBegin() {
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 0.0
      return
    }
    
    coordinator.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = 0.0
    })
  }
}

extension CustomNavigationPresentationController {
  func setupDimmingView() {
    dimmingView = UIView()
    dimmingView.backgroundColor = .gray400
    dimmingView.alpha = 0.0
    
    let recognizer = UITapGestureRecognizer(target: self,
                                            action: #selector(handleTap(recognizer:)))
    dimmingView.addGestureRecognizer(recognizer)
  }
  
  @objc func handleTap(recognizer: UITapGestureRecognizer) {
    presentingViewController.dismiss(animated: true)
  }
  
  func setupDragIndicatorView() {
    dragIndicator = UIView()
    dragIndicator.backgroundColor = UIColor(patternImage: UIImage(named: "close_indicator")!)
    presentedViewController.view.addSubview(dragIndicator)
    dragIndicator.snp.makeConstraints {
      $0.height.equalTo(8)
      $0.width.equalTo(48)
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(-20)
    }
  }
}
