//
//  IDCardGuideActions.swift
//  Keyneez
//
//  Created by Jung peter on 1/9/23.
//

import UIKit

struct IDCardGuideActions: IDCardGuideActionables {
  
  func didTouchCameraStartButton(from presenting: UIViewController, to bottomsheet: IDInfoEditableViewController) -> UIAction {
    return UIAction(handler: { _ in
      presenting.present(bottomsheet, animated: true)
    })
  }
  
}
