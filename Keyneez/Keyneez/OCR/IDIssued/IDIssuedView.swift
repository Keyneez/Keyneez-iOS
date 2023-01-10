//
//  IDIssuedView.swift
//  Keyneez
//
//  Created by Jung peter on 1/9/23.
//

import UIKit

class IDIssuedView: NiblessView {
  
  let userInfo: UserCardInfo = .init(name: "김민지", personType: "호기심 가득 문화인", birthday: "2001.01.17")

  private lazy var titleLabel: UILabel = .init().then {
    $0.text = "\(userInfo.name)님의\nID를 발급했어요!"
    $0.numberOfLines = 0
    $0.textAlignment = .left
    $0.font = .font(.pretendardBold, ofSize: 24)
    $0.textColor = .gray900
  }
  
  private lazy var idCardView: IDCardView = .init(frame: .zero, userCardInfo: userInfo, actions: actions)
  
  private lazy var confirmButton: UIButton = .init().then {
    $0.keyneezButtonStyle(style: .blackAct, title: "확인")
  }
  
  private var actions: IDCardContentActionables
  
  init(frame: CGRect, action: IDCardContentActionables) {
    self.actions = action
    super.init(frame: frame)
    addsubview()
    setConstraint()
  }
  
}

extension IDIssuedView {
  
  private func addsubview() {
    [titleLabel, idCardView, confirmButton].forEach {
      self.addSubview($0)
    }
  }
  
  private func setConstraint() {
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16)
      $0.leading.equalToSuperview().inset(24)
    }
    
    idCardView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(61)
      $0.height.equalTo(419)
      $0.top.equalToSuperview().inset(133)
      $0.bottom.equalTo(confirmButton.snp.top).offset(-64)
    }
    
    confirmButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalTo(48)
    }
    
  }
  
}
