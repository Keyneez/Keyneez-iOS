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
  private var heightIncludeKeyboard: CGFloat
  private var tempHeight: CGFloat
  private var dimmingView: UIView!
  private var dragIndicator: UIView!
  private var dragIndicatorView: UIView!
  private var dimmed: Bool
  private var keyboardHeight: CGFloat = 0 {
    didSet {
      self.containerViewWillLayoutSubviews()
    }
  }
  
  init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: PresentationDirection, height: CGFloat, dimmed: Bool, heightIncludeKeyboard: CGFloat) {
    self.direction = direction
    self.height = height
    self.dimmed = dimmed
    self.heightIncludeKeyboard = heightIncludeKeyboard
    self.tempHeight = height
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    setupDimmingView()
    setupDragIndicatorView()
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
      dimmingView.alpha = dimmed == true ? 1.0 : 0.5
      return
    }
    
    coordinator.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = self.dimmed == true ? 1.0 : 0.5
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
    dimmingView.backgroundColor = dimmed == true ? .gray400 : .black
    dimmingView.alpha = 0.0
    
    let recognizer = UITapGestureRecognizer(target: self,
                                            action: #selector(handleTap(recognizer:)))
    dimmingView.addGestureRecognizer(recognizer)
  }
  
  @objc func handleTap(recognizer: UITapGestureRecognizer) {
    presentingViewController.dismiss(animated: true)
  }
  
  @objc func keyboardWillShow(_ notification: NSNotification) {
    if keyboardHeight > 0 { return }
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardRectangle.height
      tempHeight = height
      if heightIncludeKeyboard == UIScreen.main.bounds.size.width {
        height += keyboardHeight
      }
      height = heightIncludeKeyboard
      self.keyboardHeight = keyboardHeight
    }
    
  }
  
  @objc func keyboardWillHide(_ notification: NSNotification) {
    self.height = tempHeight
    self.keyboardHeight = 0
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
