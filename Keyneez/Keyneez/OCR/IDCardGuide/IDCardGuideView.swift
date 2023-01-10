//
//  IDCardGuideView.swift
//  Keyneez
//
//  Created by Jung peter on 1/9/23.
//

import UIKit

private struct Constant {
  static let title = "학생증 또는 청소년증을\n준비해주세요."
  static let description = "청소년 인증을 위해 학생증/청소년증\n촬영이 필요해요."
  static let guideImageName = "ocr_guide"
  static let buttonTitle = "촬영 시작하기"
}

class IDCardGuideView: NiblessView {

  private lazy var titleLabel: UILabel = .init().then {
    $0.text = Constant.title
    $0.numberOfLines = 0
    $0.textAlignment = .left
    $0.font = .font(.pretendardBold, ofSize: 24)
    $0.textColor = .gray900
  }
  
  private lazy var descriptionLabel: UILabel = .init().then {
    $0.text = Constant.description
    $0.numberOfLines = 0
    $0.textAlignment = . left
    $0.textColor = .gray500
    $0.font = .font(.pretendardMedium, ofSize: 18)
  }
  
  private lazy var guideImageView: UIImageView = .init().then {
    $0.image = UIImage(named: Constant.guideImageName)
  }
  
  private lazy var cameraStartButton: UIButton = .init().then {
    $0.keyneezButtonStyle(style: .blackAct, title: Constant.buttonTitle)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview()
    setConstraint()
  }

}

extension IDCardGuideView {
  
  private func addSubview() {
    [titleLabel, descriptionLabel, guideImageView, cameraStartButton].forEach {
      self.addSubviews($0)
    }
  }
  
  private func setConstraint() {
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16)
      $0.leading.equalToSuperview().inset(24)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
    }
    
    guideImageView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.height.equalTo(200)
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(72)
    }
    
    cameraStartButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalTo(48)
      $0.bottom.equalToSuperview().inset(44)
    }
    
  }
  
}
