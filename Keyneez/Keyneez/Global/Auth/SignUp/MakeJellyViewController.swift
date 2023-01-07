//
//  MakeJellyViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/07.
//

import UIKit
import SnapKit
import Then

// MARK: - 네비게이션 추가
// MARK: - Constant

class MakeJellyViewController: UIViewController {
  
  // MARK: - UI Components
  private let titleLabel = UILabel().then {
    $0.text = "나의 젤리 만들기"
    $0.font = UIFont.font(.pretendardBold, ofSize: 24)
  }
  private let subTitleLabel = UILabel().then {
    $0.text = "나의 마음에서 태어날 젤리와\n더욱 다채로운 일상을 함께해요!"
    $0.font = UIFont.font(.pretendardMedium, ofSize: 18)
    $0.textColor = .gray500
    $0.numberOfLines = 0
  }
  private let jellyImageView = UIImageView().then {
    $0.image = UIImage(named: "jelly")
  }
  private let startButton = UIButton().then {
    $0.keyneezButtonStyle(style: .blackAct, title: "시작하기")
  }
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setConfig()
    setLayout()
  }
}

// MARK: - Extensions

extension MakeJellyViewController {
  
  // MARK: - Layout Helpers
  
  private func setConfig() {
    view.backgroundColor = .white
    [titleLabel, subTitleLabel, jellyImageView, startButton].forEach {
      view.addSubview($0)
    }
  }
  private func setLayout() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(SignUpConstant.labelTop)
      $0.leading.equalToSuperview().offset(SignUpConstant.labelLeading)
    }
    subTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(SignUpConstant.labelTop)
      $0.leading.equalTo(titleLabel)
    }
    jellyImageView.snp.makeConstraints {
      $0.top.equalTo(subTitleLabel.snp.bottom).offset(SignUpConstant.imageTop)
      $0.leading.trailing.equalToSuperview().inset(SignUpConstant.jellyImageWidth)
      $0.height.equalTo(SignUpConstant.jellyImageHeight)
    }
    startButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(SignUpConstant.buttonBottom.adjusted)
      $0.leading.trailing.equalToSuperview().inset(SignUpConstant.labelTop)
      $0.height.equalTo(SignUpConstant.buttonHeight.adjusted)
    }
    
  }
}
