//
//  DanalUserDataViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/11.
//

import UIKit
import Toast

private struct Constant {
  static let firstTextFieldTop: CGFloat = 91
  static let textFieldMargin: CGFloat = 20
  static let textFieldWidth: CGFloat = 24
  static let textFieldHeight: CGFloat = 48
}

class DanalUserDataViewController: NiblessViewController, NavigationBarProtocol, UITextFieldDelegate {
  
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .flexibleBox]).build()
  
  private lazy var backButton: UIButton = .init(primaryAction: touchUpBackButton).then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback_search"), for: .normal)
  }
  private lazy var touchUpBackButton: UIAction = .init(handler: { _ in
    self.navigationController?.popViewController(animated: true)
  })
  
  var contentView = UIView()
  
  private let titleLabel = UILabel().then {
    $0.text = "회원가입을 위해\n기본 정보를 입력해주세요."
    $0.font = .font(.pretendardBold, ofSize: 24)
    $0.numberOfLines = 0
    $0.textColor = .gray900
  }
  private lazy var nameTextField: UITextField = KeyneezTextFieldFactory.formStyleTextfield(placeholder: "이름", borderStyle: .underline(padding: 1)).build()
  
  private lazy var phoneTextField: UITextField = KeyneezTextFieldFactory.formStyleTextfield(placeholder: "휴대폰 번호", borderStyle: .underline(padding: 1)).build()
  
  private lazy var birthTextField: UITextField = KeyneezTextFieldFactory.formStyleTextfield(placeholder: "생년월일(6자)", borderStyle: .underline(padding: 1)).build()
  
  private lazy var nextButton = UIButton().then {
    $0.keyneezButtonStyle(style: .blackUnact, title: "다음으로")
    $0.addTarget(self, action: #selector(touchUpNextVC), for: .touchUpInside)
  }
  var nameTextCount: Int = 0
  var phoneTextCount: Int = 0
  var birthTextCount: Int = 0
  
  private func signUp(with dto: ProductDanalRequestDto,
                      completion: @escaping((ProductDanalResponseDto) -> Void)) {
    
    UserAPIProvider.shared.postUserInfo(param: dto) { [weak self] result in
      guard self != nil else { return }
      switch result {
      case .success(let data):
        // 같은 유저가 있을 때
        guard let userdata = data else {
          // UI change
          DispatchQueue.main.async {
            self!.view.makeToast("이미 존재하는 휴대폰 입니다.", duration: 0.7, position: .center)
          }
          return
        }
        // new one
        DispatchQueue.main.async {
          completion(userdata)
          self?.pushToNextVC(VC: JellyMakeViewController())
        }
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  @objc
  private func touchUpNextVC() {
    if let name = nameTextField.text,
       let phone = phoneTextField.text,
       let birthday = birthTextField.text {
      var danalRequestDTO = ProductDanalRequestDto(userName: name, userBirth: birthday,
                                                   userGender: " ", userPhone: phone)
        signUp(with: danalRequestDTO) { userdata in
          UserSession.shared.accessToken = userdata.accessToken
      }
    }
  }
  
  private func setKeyboard() {
    [nameTextField, phoneTextField, birthTextField].forEach {
      $0.delegate = self
      $0.becomeFirstResponder()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addNavigationViewToSubview()
    setConfig()
    setLayout()
    
  }
  
  private func setTextField() {
    nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    phoneTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    birthTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
  }
  
  @objc
  func textFieldDidChange(textField: UITextField) {
    nameTextCount = nameTextField.text!.count
    phoneTextCount = phoneTextField.text!.count
    birthTextCount = birthTextField.text!.count
    
  }
  
  private func setButton() {
    if nameTextCount > 1 && phoneTextCount == 11 && birthTextCount == 6 {
      nextButton.keyneezButtonStyle(style: .blackAct, title: "다음으로")
    } else {
      nextButton.keyneezButtonStyle(style: .blackUnact, title: "다음으로")
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setKeyboard()
    setButton()
    print("이름",nameTextField.text, "번호",phoneTextField.text, "생일", birthTextField.text)
  }
  
}
extension DanalUserDataViewController {
  private func setConfig() {
    view.backgroundColor = .gray050
    [titleLabel, phoneTextField, nameTextField, phoneTextField, birthTextField, nextButton].forEach {
      contentView.addSubview($0)
    }
  }
  private func setLayout() {
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(SignUpConstant.labelTop)
      $0.leading.equalToSuperview().offset(SignUpConstant.labelLeading)
    }
    nameTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Constant.firstTextFieldTop)
      $0.leading.trailing.equalToSuperview().inset(Constant.textFieldWidth)
      $0.height.equalTo(Constant.textFieldHeight)
    }
    phoneTextField.snp.makeConstraints {
      $0.top.equalTo(nameTextField.snp.bottom).offset(Constant.textFieldMargin)
      $0.leading.trailing.equalTo(nameTextField)
      $0.height.equalTo(nameTextField)
    }
    birthTextField.snp.makeConstraints {
      $0.top.equalTo(phoneTextField.snp.bottom).offset(Constant.textFieldMargin)
      $0.leading.trailing.equalTo(nameTextField)
      $0.height.equalTo(nameTextField)
    }
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(40)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalTo(SignUpConstant.buttonHeight)
    }
  }
}
