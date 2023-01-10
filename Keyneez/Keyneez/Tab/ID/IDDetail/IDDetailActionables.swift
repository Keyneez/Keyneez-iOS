//
//  IDViewActionable.swift
//  Keyneez
//
//  Created by Jung peter on 1/6/23.
//

import UIKit

protocol IDDetailActionables {
  func touchAuthentication(to target: NiblessViewController) -> UIAction
}

final class IDDetailActions: IDDetailActionables {
  
  private weak var viewController: NiblessViewController?
  
  func touchAuthentication(to target: NiblessViewController) -> UIAction {
    return UIAction(handler: { [weak self] _ in
      target.modalPresentationStyle = .fullScreen
      self?.viewController?.present(target, animated: true)
    })
  }

  init(viewController: NiblessViewController) {
    self.viewController = viewController
  }
  
}
