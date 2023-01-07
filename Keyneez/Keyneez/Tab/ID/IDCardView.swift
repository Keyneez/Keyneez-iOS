//
//  IDCardView.swift
//  Keyneez
//
//  Created by Jung peter on 1/5/23.
//

import UIKit

private struct Constant {
  static let personLabelFontSize: CGFloat = 12
  static let nameLabelFontSize: CGFloat = 28
  static let birthdayLabelFontSize: CGFloat = 14
  static let buttonIconImageName = "ic_dropdown_right"
  static let characterSize: (width: CGFloat, height: CGFloat) = (180, 205)
  static let characterBottomInset: CGFloat = 213
  static let cardTopInset: CGFloat = 101
  static let labelLeading: CGFloat = 23
  static let labelTopOffset: CGFloat = 155
  static let labelBottomOffset: CGFloat = -4
  static let buttonWidth = 32
  static let birthdayLabelBottomInset = 55
}

class IDCardView: NiblessView {
  
  private lazy var characterView: UIImageView = .init().then {
    $0.image = UIImage(named: "test_character")!
  }
  
  private lazy var cardView: UIImageView = .init().then {
    $0.image = UIImage(named: "card_bg_mint")
    $0.contentMode = .scaleToFill
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
  
  private lazy var birthdayLabel: UILabel = .init().then {
    $0.font = .font(.pretendardMedium, ofSize: Constant.birthdayLabelFontSize)
    $0.textColor = .gray050
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
    [cardView, characterView].forEach { self.addSubview($0) }
    [personTypeLabel, nameLabel, showDetailIDButton, birthdayLabel].forEach { self.cardView.addSubview($0) }
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
      $0.width.equalTo(Constant.characterSize.width)
      $0.top.equalToSuperview()
      $0.height.equalTo(Constant.characterSize.height)
      $0.bottom.equalTo(cardView.snp.bottom).inset(Constant.characterBottomInset)
    }
    
    cardView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalToSuperview().inset(Constant.cardTopInset)
    }
    
    personTypeLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(Constant.labelLeading)
      $0.top.equalToSuperview().offset(Constant.labelTopOffset)
      $0.bottom.equalTo(nameLabel.snp.top).offset(Constant.labelBottomOffset)
    }
    
    nameLabel.snp.makeConstraints {
      $0.leading.equalTo(personTypeLabel)
      $0.trailing.equalTo(showDetailIDButton.snp.leading)
    }
    
    showDetailIDButton.snp.makeConstraints {
      $0.height.width.equalTo(Constant.buttonWidth)
      $0.top.equalTo(nameLabel.snp.top)
    }
    
    birthdayLabel.snp.makeConstraints {
      $0.leading.equalTo(personTypeLabel.snp.leading)
      $0.bottom.equalToSuperview().inset(Constant.birthdayLabelBottomInset)
    }
    
  }
  
}
