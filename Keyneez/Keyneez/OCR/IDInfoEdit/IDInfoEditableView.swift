//
//  IDInfoEditableView.swift
//  Keyneez
//
//  Created by Jung peter on 1/9/23.
//

import UIKit

enum IDType: String {
  case schoolID = "학교"
  case teenID = "생년월일"
  
  var title: String {
    switch self {
    case .schoolID:
      return "학교"
    case .teenID:
      return "청소년증"
    }
  }
  
  var placeholder: String {
    switch self {
    case .teenID:
      return "YYMMDD"
    case .schoolID:
      return "OO학교"
    }
  }
}

struct IDInfo {
  var name: String
  var idType: IDType
  var info: String
}

final class IDInfoEditableView: NiblessView {
  
  private var idSegmentedValue: [IDInfo] = [IDInfo(name: "", idType: .schoolID, info: ""),
                                            IDInfo(name: "", idType: .teenID, info: "")]
  
  private lazy var titleLabel: UILabel = .init().then {
    $0.text = "아래의 정보가 맞나요?"
    $0.textColor = .gray900
    $0.font = .font(.pretendardBold, ofSize: 24)
  }
  
  private lazy var nameTextFieldTitleLabel = makeTextfieldTitle(with: "이름")
  private lazy var nameTextField: UITextField = KeyneezTextFieldFactory.formStyleTextfield(placeholder: "OOO", borderStyle: .underlineIcon(icon: "ic_edit_gray")).build()
  
  private lazy var segmentedControl: UISegmentedControl = .init(items: idSegmentedValue.map { $0.idType.title } ).then {
    $0.addAction(changeIDTypeUI(), for: .valueChanged)
    $0.selectedSegmentTintColor = .gray900
    setSegmentedControlFontAndColor(with: $0)
  }
  
  private lazy var infoTextFieldTitleLabel = makeTextfieldTitle(with: infoTextFieldTitle)
  private lazy var infoTextField: UITextField = KeyneezTextFieldFactory.formStyleTextfield(placeholder: infoPlaceHolder, borderStyle: .underlineIcon(icon: "ic_edit_gray"), completion: { [weak self] (str) in
    guard let self else {return}
    self.idSegmentedValue[self.segmentedControl.selectedSegmentIndex].info = str ?? ""
  }).build()
  
  private lazy var recaptureButton: UIButton = .init().then {
    $0.keyneezButtonStyle(style: .whiteAct, title: "다시 촬영")
  }
  
  private lazy var continueButton: UIButton = .init().then {
    $0.keyneezButtonStyle(style: .blackUnact, title: "네, 맞아요")
  }
  
  private lazy var nameStackView: UIStackView = makeStackView(arrangedSubviews: [nameTextFieldTitleLabel, nameTextField])
  private lazy var infoStackView: UIStackView = makeStackView(arrangedSubviews: [infoTextFieldTitleLabel, infoTextField])
  private lazy var buttonStackView: UIStackView = makeButtonStackView(arrangedSubviews: [recaptureButton, continueButton])
  
  private var infoPlaceHolder = "OO학교" {
    didSet {
      self.infoTextField.placeholder = infoPlaceHolder
    }
  }
  
  private var infoTextFieldTitle = "학교" {
    didSet {
      self.infoTextFieldTitleLabel.text = infoTextFieldTitle
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addsubview()
    setConstraint()
    setSegmentedControl()
    nameTextField.delegate = self
    infoTextField.delegate = self
  }
  
}

// MARK: - TextField Delegate
extension IDInfoEditableView: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == nameTextField {
      self.idSegmentedValue[self.segmentedControl.selectedSegmentIndex].name = textField.text ?? ""
    } else {
      self.idSegmentedValue[self.segmentedControl.selectedSegmentIndex].info = textField.text ?? ""
    }
    checkTextFields()
  }
}

// MARK: - Business Logic

extension IDInfoEditableView {
  
  private func setSegmentedControl() {
    segmentedControl.selectedSegmentIndex = 0
  }
  
  private func changeIDTypeUI() -> UIAction {
    return UIAction(handler: { _ in
      self.infoTextFieldTitle = self.idSegmentedValue[self.segmentedControl.selectedSegmentIndex].idType.rawValue
      self.infoPlaceHolder = self.idSegmentedValue[self.segmentedControl.selectedSegmentIndex].idType.placeholder
      self.nameTextField.text = self.idSegmentedValue[self.segmentedControl.selectedSegmentIndex].name
      self.infoTextField.text = self.idSegmentedValue[self.segmentedControl.selectedSegmentIndex].info
      self.checkTextFields()
    })
  }
  
  private func checkTextFields() {
    if !self.idSegmentedValue[self.segmentedControl.selectedSegmentIndex].name.isEmpty && !self.idSegmentedValue[self.segmentedControl.selectedSegmentIndex].info.isEmpty {
      self.continueButton.keyneezButtonStyle(style: .blackAct, title: "네, 맞아요")
    } else {
      self.continueButton.keyneezButtonStyle(style: .blackUnact, title: "네, 맞아요")
    }
  }
  
}

// MARK: - UI

extension IDInfoEditableView {
  
  private func makeTextfieldTitle(with text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = .font(.pretendardMedium, ofSize: 14)
    label.textColor = .gray900
    return label
  }
  
  private func addsubview() {
    
    [titleLabel,segmentedControl, nameStackView, infoStackView, buttonStackView].forEach { self.addSubview($0)}
  }
  
  private func setSegmentedControlFontAndColor(with segmentedControl: UISegmentedControl) {
    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray050,
                                             NSAttributedString.Key.font: UIFont.font(.pretendardSemiBold, ofSize: 16)],
                                            for: UIControl.State.selected)
    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray400,
                                             NSAttributedString.Key.font: UIFont.font(.pretendardSemiBold, ofSize: 16)],
                                            for: UIControl.State.normal)
  }
  
  private func setConstraint() {
    
    titleLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview().inset(24)
      $0.bottom.equalTo(segmentedControl.snp.top).offset(-32)
    }
    
    segmentedControl.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.height.equalTo(40)
      $0.bottom.equalTo(nameStackView.snp.top).offset(-32)
    }
    
    nameTextField.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    infoTextField.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    nameStackView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.height.equalTo(65)
      $0.bottom.equalTo(infoStackView.snp.top).offset(-24)
    }
    
    infoStackView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.height.equalTo(65)
      $0.bottom.equalTo(buttonStackView.snp.top).offset(-111)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.height.equalTo(48)
      //      $0.bottom.equalToSuperview().offset(-44)
      $0.leading.trailing.equalToSuperview().inset(16)
    }
    
  }
  
  private func makeStackView(arrangedSubviews: [UIView]) -> UIStackView {
    let stackView: UIStackView = .init(arrangedSubviews: arrangedSubviews)
    stackView.alignment = .leading
    stackView.distribution = .fill
    stackView.axis = .vertical
    return stackView
  }
  
  private func makeButtonStackView(arrangedSubviews: [UIView]) -> UIStackView {
    let stackView: UIStackView = .init(arrangedSubviews: arrangedSubviews)
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 7
    stackView.axis = .horizontal
    return stackView
  }
}
