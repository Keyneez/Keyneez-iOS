//
//  IDInfoEditableActionables.swift
//  Keyneez
//
//  Created by Jung peter on 1/10/23.
//

import UIKit

protocol IDInfoEditableActionables {
  func dismiss() -> UIAction
  func continueToIDIssuedViewController(with factory: IDIssuedFactory) -> UIAction
}

final class IDInfoEditableActions: IDInfoEditableActionables {
  
  private weak var viewcontroller: NiblessViewController?
  
  init(viewController: NiblessViewController) {
    self.viewcontroller = viewController
  }
  
  func dismiss() -> UIAction {
    UIAction(handler: { [weak self] _ in
      self?.viewcontroller?.dismiss(animated: true)
    })
  }
  
  func continueToIDIssuedViewController(with factory: IDIssuedFactory) -> UIAction {
    let vc = factory.makeIDIssuedViewController()
    return UIAction(handler: { [weak self] _ in
      vc.modalPresentationStyle = .fullScreen
      self?.viewcontroller?.present(vc, animated: true)
    })
  }
  
  
}
