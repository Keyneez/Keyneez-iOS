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
  static let IDcardViewLeading: CGFloat = 53
  static let IDCardTop: CGFloat = 55
  static let IDCardBottom: CGFloat = -20
  static let idSeperatedButtonheight: CGFloat = 44
  static let idSeparatedBottom: CGFloat = 158
}

class IDCardContentView: NiblessView {
  
  private lazy var idCardView: IDCardView = .init(frame: .zero, userCardInfo: Constant.usercardInfo, actions: actions)
  
  private var actions: IDCardContentActionables
  
  private lazy var idSeperateButton: SeperatedButton = .init(frame: .zero, title: Constant.titles, actions: [actions.touchBenefitInfo(), actions.touchRealIDCardAuth()])
  
  init(frame: CGRect, actions: IDCardContentActionables) {
    self.actions = actions
    super.init(frame: frame)
    addSubview()
    setConstraint()
  }
  
  private func addSubview() {
    [idCardView, idSeperateButton].forEach { self.addSubview($0) }
  }
  
  private func setConstraint() {
    
    idCardView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(Constant.IDcardViewLeading)
      $0.top.equalToSuperview().inset(Constant.IDCardTop)
      $0.bottom.equalTo(idSeperateButton.snp.top).offset(Constant.IDCardBottom)
    }
    
    idSeperateButton.snp.makeConstraints {
      $0.leading.equalTo(idCardView.snp.leading)
      $0.trailing.equalTo(idCardView.snp.trailing)
      $0.height.equalTo(Constant.idSeperatedButtonheight)
      $0.bottom.equalToSuperview().inset(Constant.idSeparatedBottom)
    }
    
  }
 
}
