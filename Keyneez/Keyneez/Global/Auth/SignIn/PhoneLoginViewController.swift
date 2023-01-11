//
//  FaceIDViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/11.
//

import UIKit
import SnapKit
import Then

class PhoneLoginViewController: NiblessViewController, NavigationBarProtocol, UITextFieldDelegate {
  
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .flexibleBox]).build()
  
  private lazy var backButton: UIButton = .init(primaryAction: touchUpBackButton).then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback_search"), for: .normal)
  }
  private lazy var touchUpBackButton: UIAction = .init(handler: { _ in
    self.navigationController?.popViewController(animated: true)
  })
  
  var contentView = UIView()
  
  private let titleLabel = UILabel().then {
    $0.text = "로그인을 위해\n휴대폰 번호를 입력해주세요."
    $0.font = .font(.pretendardBold, ofSize: 24)
    $0.numberOfLines = 0
    $0.textColor = .gray900
  }
  private lazy var phoneTextField: UITextField = KeyneezTextFieldFactory.formStyleTextfield(placeholder: "휴대폰 번호", borderStyle: .underline(padding: 1)).build()
  
  private let nextButton = UIButton().then {
    $0.keyneezButtonStyle(style: .blackUnact, title: "다음으로")
    $0.addTarget(self, action: #selector(touchUpNextVC), for: .touchUpInside)
  }
  
  @objc
  private func touchUpNextVC() {
    pushToNextVC(VC: SimpleLoginViewController())
  }
  
  private func setKeyboard() {
    phoneTextField.delegate = self
    phoneTextField.becomeFirstResponder()
    phoneTextField.keyboardType = .phonePad
  }
  
  var textCount = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addNavigationViewToSubview()
    setConfig()
    setLayout()
    phoneTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
  }
  override func viewWillDisappear(_ animated: Bool) {
    self.phoneTextField.becomeFirstResponder()
  }
  
  @objc
  func textFieldDidChange(textField: UITextField) {
    textCount = phoneTextField.text!.count
    setButton()
  }
  
  private func setButton() {
    if textCount == 11 {
      nextButton.keyneezButtonStyle(style: .blackAct, title: "다음으로")
      phoneTextField.resignFirstResponder()
    } else {
      nextButton.keyneezButtonStyle(style: .blackUnact, title: "다음으로")
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setKeyboard()
    
  }
  
}
extension PhoneLoginViewController {
  private func setConfig() {
    view.backgroundColor = .gray050
    [titleLabel, phoneTextField, nextButton].forEach {
      contentView.addSubview($0)
    }
  }
  private func setLayout() {
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(SignUpConstant.labelTop)
      $0.leading.equalToSuperview().offset(SignUpConstant.labelLeading)
    }
    phoneTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(91)
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.height.equalTo(48)
    }
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(40)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalTo(SignUpConstant.buttonHeight)
    }
  }
}
