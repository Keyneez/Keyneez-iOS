//
//  JellyDetailView.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/10.
//

import UIKit
import SnapKit
import Then

private struct Constant {
  static let titleTop: CGFloat = 40
  static let titleBottom: CGFloat = 8
  static let jellyType: CGFloat = 32
  static let hashTagBottom: CGFloat = 8
  static let imageSize: CGFloat = 156
}

class JellyDetailView: UIView {
  //MARK: - UI Components
  private let userNameLabel: UILabel = .init().then {
    $0.text = "민지's jelly"
    $0.textColor = .gray700
    $0.font = .font(.pretendardSemiBold, ofSize: 14)
  }

  private let jellyTypeLabel: UILabel = .init().then {
    $0.text = "호기심 가득 문화인"
    $0.font = .font(.pretendardBold, ofSize: 24)
    $0.textColor = .gray900
  }
  private let itemImageView: UIImageView = .init().then {
    $0.image = UIImage(named: "headset")
    $0.contentMode = .scaleAspectFit
  }
  private let hashTagLabel: UILabel = .init().then {
    $0.text = "#문화생활 #호기심 가득"
    $0.textColor = .gray900
    $0.font = .font(.pretendardBold, ofSize: 16)
  }
  private let hashTagContext: UILabel = .init().then {
    $0.text = "오늘은 또 어떤 활동들을 해볼까? 이곳저곳 둘러보는 \n눈빛이 더욱 빛나는 날 ! 당신의 호기심 가득한 문화생활이  \n더욱 풍부해질 수 있도록 키니즈가 안내해 줄게요!🐥"
    $0.numberOfLines = 0
    $0.textAlignment = .center
    $0.textColor = .gray900
    $0.font = .font(.pretendardMedium, ofSize: 14)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setConfig()
    setLayout()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension JellyDetailView {
  private func setConfig() {
    [userNameLabel, jellyTypeLabel, itemImageView, hashTagLabel, hashTagContext].forEach {
      self.addSubview($0)
    }
  }
  private func setLayout() {
    userNameLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Constant.titleTop)
      $0.centerX.equalToSuperview()
    }
    jellyTypeLabel.snp.makeConstraints {
      $0.top.equalTo(userNameLabel.snp.bottom).offset(Constant.titleBottom)
      $0.centerX.equalToSuperview().inset(Constant.hashTagBottom)
    }
    itemImageView.snp.makeConstraints {
      $0.top.equalTo(jellyTypeLabel.snp.bottom).offset(Constant.jellyType)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(Constant.imageSize)
    }
    hashTagLabel.snp.makeConstraints {
      $0.top.equalTo(itemImageView.snp.bottom).offset(Constant.jellyType)
      $0.centerX.equalToSuperview()
    }
    hashTagContext.snp.makeConstraints {
      $0.top.equalTo(hashTagLabel.snp.bottom).offset(Constant.hashTagBottom)
      $0.centerX.equalToSuperview()
    }
  }
}
