//
//  CameraViewActions.swift
//  Keyneez
//
//  Created by Jung peter on 1/11/23.
//

import UIKit

protocol CameraViewActionables {
  func didTouchBackButton() -> UIAction
  func OCRConfirmed(with navigationDelegate: CustomNavigationManager, height: CGFloat, heightIncludeKeyboard: CGFloat,text: [String], image: UIImage)
}

final class CameraViewActions: CameraViewActionables {
  
  private weak var viewcontroller: CameraViewController?
  
  init(viewcontroller: CameraViewController? = nil) {
    self.viewcontroller = viewcontroller
  }
  
  func didTouchBackButton() -> UIAction {
    return UIAction(handler: { _ in
      self.viewcontroller?.dismiss(animated: true)
    })
  }
  
  func OCRConfirmed(with navigationDelegate: CustomNavigationManager,
                    height: CGFloat,
                    heightIncludeKeyboard: CGFloat,
                    text: [String],
                    image: UIImage
    ) {
    DispatchQueue.main.async {
      navigationDelegate.direction = .bottom
      navigationDelegate.height = height
      navigationDelegate.heightIncludeKeyboard = heightIncludeKeyboard
      navigationDelegate.dimmed = false
      guard let viewController = self.viewcontroller else {return}
      let idInfoEditVC = IDInfoEditableViewController(ocrTexts: text, camera: viewController.camera, OCRService: viewController.ocrService)
      idInfoEditVC.transitioningDelegate = navigationDelegate
      idInfoEditVC.modalPresentationStyle = .custom
      self.viewcontroller?.present(idInfoEditVC, animated: true)
    }
  }
  
  deinit {
    print("\(self) deinit")
  }
  
}
