//
//  IDIssuedViewActionables.swift
//  Keyneez
//
//  Created by Jung peter on 1/10/23.
//

import UIKit

protocol IDIssuedViewActionables {
  func didTouchBackButton() -> UIAction
  func didTouchConfirmButton() -> UIAction
  func touchDetailInfo(to target: BottomSheetViewController) -> UIAction
}

final class IDIssuedViewActions: IDIssuedViewActionables {
 
  private weak var viewController: NiblessViewController?
  
  init(viewController: NiblessViewController) {
    self.viewController = viewController
  }
  
  func didTouchBackButton() -> UIAction {
    return UIAction { [weak self] _ in
      self?.viewController?.dismiss(animated: true)
    }
  }
  
  func touchDetailInfo(to target: BottomSheetViewController) -> UIAction {
    return UIAction(handler: { _ in
      guard let vc = self.viewController else {return}
      vc.present(target, animated: true)
    })
  }
  
  func didTouchConfirmButton() -> UIAction {
    return UIAction { [weak self] _ in
    
      //서버통신
      
      UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first?.rootViewController?.dismiss(animated: true)
    }
  }
  
}
