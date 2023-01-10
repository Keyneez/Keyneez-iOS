//
//  PhysicalActions.swift
//  Keyneez
//
//  Created by Jung peter on 1/10/23.
//

import UIKit

class PhysicalIDActions: PhysicalIDActionables {
  
  private weak var viewController: NiblessViewController?
  
  init(viewcontroller: NiblessViewController) {
    self.viewController = viewcontroller
  }
  
  func dismiss() -> UIAction {
    return UIAction(handler: { [weak self] _ in
      self?.viewController?.dismiss(animated: true)
    })
  }
  
}
