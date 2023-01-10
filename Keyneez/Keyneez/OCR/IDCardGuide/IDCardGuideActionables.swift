//
//  IDCardGuideable.swift
//  Keyneez
//
//  Created by Jung peter on 1/9/23.
//

import UIKit

protocol IDCardGuideActionables {
  func didTouchCameraStartButton(from presenting: UIViewController, to bottomsheet: IDInfoEditableViewController) -> UIAction
}
