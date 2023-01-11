//
//  CameraViewActions.swift
//  Keyneez
//
//  Created by Jung peter on 1/11/23.
//

import UIKit

protocol CameraViewActionables {
  func didTouchBackButton() -> UIAction
  func OCRConfirmed(with navigationDelegate: CustomNavigationManager, height: CGFloat, heightIncludeKeyboard: CGFloat) -> UIAction
}

final class CameraViewActions: CameraViewActionables {
  
  private weak var viewcontroller: NiblessViewController?
  
  init(viewcontroller: NiblessViewController? = nil) {
    self.viewcontroller = viewcontroller
  }
  
  func didTouchBackButton() -> UIAction {
    return UIAction(handler: { _ in
      self.viewcontroller?.dismiss(animated: true)
    })
  }
  
  func OCRConfirmed(with navigationDelegate: CustomNavigationManager,
                    height: CGFloat,
                    heightIncludeKeyboard: CGFloat) -> UIAction {
    return UIAction(handler: { [unowned self] _ in
      navigationDelegate.direction = .bottom
      navigationDelegate.height = height
      navigationDelegate.heightIncludeKeyboard = heightIncludeKeyboard
      navigationDelegate.dimmed = false
      let idInfoEditVC = IDInfoEditableViewController()
      idInfoEditVC.transitioningDelegate = navigationDelegate
      idInfoEditVC.modalPresentationStyle = .custom
      self.viewcontroller?.present(idInfoEditVC, animated: true)
    })
  }
  
  deinit {
    print("\(self) deinit")
  }
  
}
