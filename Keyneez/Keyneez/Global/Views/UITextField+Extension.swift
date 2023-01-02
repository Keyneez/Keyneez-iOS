//
//  UIView+Extension.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/02.
//

import UIKit
import Then

enum KeyneezTextFieldFactory: Buildable {

    typealias ViewType = UITextField

    enum TextfieldBorderStyle {
      case underline
      case underlineIcon
    }

    case formStyleTextfield(placeholder: String, borderStyle: TextfieldBorderStyle)

    func build(_ config: ((ViewType) -> Void)? = nil) -> ViewType {
        switch self {
        case .formStyleTextfield(let placeholder, let borderStyle):
            var textfield =  makeTextField(placeholer: placeholder, borderstyle: borderStyle)
            if let config = config {
                textfield = textfield.then(config)
            }
            return textfield
        }
    }

    private func makeTextField(placeholer: String, borderstyle: TextfieldBorderStyle) -> ViewType {
        return UITextField().then {
            $0.placeholder = placeholer
            $0.textColor = .lightGray
            if borderstyle == .underline {
                $0.underlineStyle()
            } else if borderstyle == .round {
                $0.borderStyle = .roundedRect
            }
        }
    }

}
