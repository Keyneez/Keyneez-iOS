//
//  IDCardView.swift
//  Keyneez
//
//  Created by Jung peter on 1/5/23.
//

import UIKit

private struct Constant {
  static let imageviewName = "id_mark"
  static let personLabelFontSize: CGFloat = 12
  static let nameLabelFontSize: CGFloat = 28
  static let birthdayLabelFontSize: CGFloat = 14
  static let buttonIconImageName = "ic_dropdown_right"
}

class IDCardView: NiblessView {
  
  private lazy var characterView: UIImageView = .init().then {
    $0.image = UIImage(named: "test_character")!
  }
  
  private lazy var cardView: UIView = .init().then {
    $0.backgroundColor = UIColor(patternImage: UIImage(named: "test_cardView")!)
  }
  
  private lazy var personTypeLabel: UILabel = .init().then {
    $0.font = .font(.pretendardMedium, ofSize: Constant.personLabelFontSize)
    $0.textColor = .gray050
  }
  
  private lazy var nameLabel: UILabel = .init().then {
    $0.font = .font(.pretendardBold, ofSize: Constant.nameLabelFontSize)
    $0.textColor = .gray050
  }
  
  private lazy var showDetailIDButton: UIButton = .init(primaryAction: actions.touchDetailInfo()).then {
    $0.setBackgroundImage(UIImage(named: Constant.buttonIconImageName), for: .normal)
  }
  
  private lazy var separateView: UIView = .init().then {
    $0.backgroundColor = .gray050
  }
  
  private lazy var birthdayLabel: UILabel = .init().then {
    $0.font = .font(.pretendardMedium, ofSize: Constant.birthdayLabelFontSize)
    $0.textColor = .gray050
  }
  
  private lazy var logoImageView: UIImageView = .init().then {
    $0.image = UIImage(named: Constant.imageviewName)!
  }
  
  private var actions: IDCardContentActionables
  
  init(frame: CGRect, userCardInfo: UserCardInfo, actions: IDCardContentActionables) {
    self.actions = actions
    super.init(frame: frame)
    addSubview()
    setConstraint()
    setLabelText(with: userCardInfo)
  }
  
}

// MARK: - Private Method

extension IDCardView {
  
  private func addSubview() {
    [characterView, cardView].forEach { self.addSubview($0) }
    [personTypeLabel, nameLabel, showDetailIDButton, separateView, birthdayLabel, logoImageView].forEach { self.cardView.addSubview($0) }
  }
  
  private func setLabelText(with userCardInfo: UserCardInfo) {
    personTypeLabel.text = userCardInfo.personType
    nameLabel.text = userCardInfo.name
    birthdayLabel.text = userCardInfo.birthday
  }
  
  // TODO: 여기 어떻게 UI잡을지 Design이랑 상의
  private func setConstraint() {
    
    characterView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview()
      $0.bottom.equalTo(cardView.snp.top).offset(100)
    }
    
    cardView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    personTypeLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(23)
      $0.top.equalToSuperview().offset(155)
      $0.bottom.equalTo(nameLabel.snp.top).offset(-4)
    }
    
    nameLabel.snp.makeConstraints {
      $0.leading.equalTo(personTypeLabel)
      $0.trailing.equalTo(showDetailIDButton.snp.leading)
    }
    
    showDetailIDButton.snp.makeConstraints {
      $0.height.width.equalTo(32)
    }
    
    separateView.snp.makeConstraints {
      $0.top.equalTo(showDetailIDButton.snp.bottom).offset(28.5)
      $0.leading.trailing.equalToSuperview().inset(23)
      $0.bottom.equalTo(birthdayLabel.snp.top).offset(-12)
    }
    
    birthdayLabel.snp.makeConstraints {
      $0.leading.equalTo(personTypeLabel.snp.leading)
    }
    
    logoImageView.snp.makeConstraints {
      $0.top.equalTo(birthdayLabel)
      $0.trailing.equalTo(separateView.snp.trailing)
      $0.height.width.equalTo(48)
    }
    
  }
  
}
