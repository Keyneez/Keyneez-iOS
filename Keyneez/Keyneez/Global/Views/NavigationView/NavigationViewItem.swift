//
//  NavigationViewItem.swift
//  Keyneez
//
//  Created by Jung peter on 1/3/23.
//

import UIKit

enum NavigationItemView {
  
  case logo
  case title(content: String)
  case iconButton(with: UIButton)
  case button(with: UIButton)
  case flexibleBox
  case textfield(configure: (placeholder: String, completion: ((String?) -> Void)?))
  case sizedBox(width: CGFloat)
  
  var image: UIImage? {
    switch self {
    case .logo:
      return UIImage(named: "logoA")
    case .flexibleBox, .sizedBox, .title, .button, .iconButton:
      return nil
    case .textfield:
      return nil
    }
  }
}
