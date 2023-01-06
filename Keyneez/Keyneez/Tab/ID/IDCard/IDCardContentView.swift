//
//  IDCardContentView.swift
//  Keyneez
//
//  Created by Jung peter on 1/6/23.
//

import UIKit

struct UserCardInfo {
  var name: String
  var personType: String
  var birthday: String
}

private struct Constant {
  static let titles: [String] = ["혜택안내", "실물인증"]
  static let usercardInfo = UserCardInfo(name: "김민지", personType: "호기심 가득 문화인", birthday: "2001.01.17")
}

class IDCardContentView: NiblessView {
  
  private lazy var IDcardView: IDCardView = .init(frame: .zero, userCardInfo: Constant.usercardInfo, actions: actions)
  
  private var actions: IDCardContentActionables
  
  private lazy var idSeperateButton: SeperatedButton = .init(frame: .zero, title: Constant.titles, actions: [actions.touchBenefitInfo(), actions.touchRealIDCardAuth()])
  
  init(frame: CGRect, actions: IDCardContentActionables) {
    self.actions = actions
    super.init(frame: frame)
    addSubview()
    
  }
  
  private func addSubview() {
    [IDcardView, idSeperateButton].forEach { self.addSubview($0) }
  }
  
  private func setConstraint() {
    
    IDcardView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(53)
      $0.top.equalToSuperview().inset(55)
      $0.bottom.equalTo(idSeperateButton.snp.top).offset(-20)
    }
    
    idSeperateButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(53)
      $0.bottom.equalToSuperview().inset(64)
    }
    
  }
 
}
