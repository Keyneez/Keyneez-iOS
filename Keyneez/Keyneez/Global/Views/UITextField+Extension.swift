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

extension UITextField {
  
  fileprivate class Constant {
    static let textFieldHeight: CGFloat = 48
    static let padding: CGFloat = 24
  }
  
  func underlineStyle(textColor: UIColor = .gray900,
                      borderColor: UIColor = .gray400,
                      padding: CGFloat = Constant.padding,
                      height: CGFloat = Constant.textFieldHeight) {
    self.borderStyle = .none
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0,
                              y: height,
                              width: UIScreen.main.bounds.width - (2 * padding),
                              height: 1)
    bottomLine.backgroundColor = borderColor.cgColor
    self.layer.addSublayer(bottomLine)
    self.textColor = textColor
  }
  
  func setPlaceholderColorAndFont(_ placeholderColor: UIColor, font: UIFont) {
    attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : placeholderColor, .font: font].compactMapValues{$0})
  }
}
