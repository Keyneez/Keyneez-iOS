//
//  IDViewActionable.swift
//  Keyneez
//
//  Created by Jung peter on 1/6/23.
//

import UIKit

protocol IDDetailActionables {
  func touchAuthentication() -> UIAction
}

final class IDDetailActions: IDDetailActionables {
  
  func touchAuthentication() -> UIAction {
    return UIAction(handler: {_ in })
  }

  init() { }
  
}
