//
//  KeyneezTextFieldFactory.swift
//  Keyneez
//
//  Created by Jung peter on 1/3/23.
//

import UIKit

private struct Constant {
  static let fontSize: CGFloat = 18
  static let searchButtonHeight: CGFloat = 32
  static let searchTextfieldHeight: CGFloat = 48
  static let searchButtonOrigin: CGFloat = (searchTextfieldHeight - searchButtonHeight) / 2
  static let searchButtonImageName: String = "ic_search"
}

enum KeyneezTextFieldFactory: Buildable {
  
  typealias ViewType = UITextField
  typealias SearchCompletion = ((String?) -> Void)?
  
  enum TextfieldBorderStyle {
    case underline
    case underlineIcon
  }
  
  case formStyleTextfield(placeholder: String, borderStyle: TextfieldBorderStyle, completion: SearchCompletion = nil)
  
  func build(_ config: ((ViewType) -> Void)? = nil) -> ViewType {
    switch self {
    case .formStyleTextfield(let placeholder, let borderStyle, let completion):
      var textfield = makeTextField(placeholer: placeholder, borderstyle: borderStyle, completion: completion)
      if let config = config {
        textfield = textfield.then(config)
      }
      return textfield
    }
  }

}

// MARK: - Private Method

extension KeyneezTextFieldFactory {
  
  private func makeTextField(placeholer: String, borderstyle: TextfieldBorderStyle, completion: SearchCompletion = nil) -> ViewType {
    return UITextField().then {
      $0.placeholder = placeholer
      $0.font = .font(.pretendardMedium, ofSize: Constant.fontSize)
      $0.setPlaceholderColorAndFont(.gray400, font: .font(.pretendardMedium, ofSize: Constant.fontSize))
      switchTextFieldStyle(to: $0, with: borderstyle, completion: completion)
    }
  }
  
  private func switchTextFieldStyle(to textfield: UITextField,
                                    with borderStyle: TextfieldBorderStyle,
                                    completion: SearchCompletion) {
    switch borderStyle {
    case .underline:
      textfield.underlineStyle()
    case .underlineIcon:
      addSearchButton(to: textfield, with: completion)
    }
  }
  
  private func addSearchButton(to textfield: UITextField, with completion: SearchCompletion) {
    
    let searchButton = makeSearchButton()
    searchButton.addAction(UIAction(handler: { _ in completion?(textfield.text) }), for: .touchUpInside)
    
    let rightview = makeRightView()
    rightview.addSubview(searchButton)
    searchButton.frame = CGRect(x: Constant.searchButtonOrigin * 2, y: Constant.searchButtonOrigin, width: Constant.searchButtonHeight, height: Constant.searchButtonHeight)
    
    textfield.underlineStyle()
    textfield.rightViewMode = .always
    textfield.rightView = rightview
  }
  
  private func makeRightView() -> UIView {
    return UIView(frame: CGRect(x: 0, y: 0, width: Constant.searchTextfieldHeight, height: Constant.searchTextfieldHeight))
  }
  
  private func makeSearchButton() -> UIButton {
    return UIButton(frame: .zero).then {
      $0.setBackgroundImage(UIImage(named: Constant.searchButtonImageName), for: .normal)
    }
  }
  
}
