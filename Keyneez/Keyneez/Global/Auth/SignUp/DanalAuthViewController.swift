//
//  DanalAuthViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/07.
//

import UIKit
import Then

// TODO: - 네비게이션 추가 !!

// MARK: - Constant

struct SignUpConstant {
  static let labelTop: CGFloat = 16
  static let labelLeading: CGFloat = 24
  static let imageTop: CGFloat = 117
  static let phoneImageWidth: CGFloat = 64
  static let phoneImageHeight: CGFloat = 276
  static let buttonBottom: CGFloat = 40
  static let buttonHeight: CGFloat = 48
  static let jellyImageTop: CGFloat = 117
  static let jellyImageWidth: CGFloat = 92
  static let jellyImageHeight: CGFloat = 220
}

class DanalAuthViewController: UIViewController {
  
  // MARK: - UI Components
  
 private lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .flexibleBox]).build()
  
  private let backButton = UIButton().then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback"), for: .normal)
  }
  
  private let titleLabel = UILabel().then {
    $0.text = "휴대폰 인증을\n진행해주세요."
    $0.font = UIFont.font(.pretendardBold, ofSize: 24)
    $0.numberOfLines = 0
  }
  
  private let phoneImageView = UIImageView().then {
    $0.image = UIImage(named: "phone_img")
  }
  
  private let authButton = UIButton().then {
    $0.keyneezButtonStyle(style: .blackAct, title: "휴대폰 인증하기")
  }
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setConfig()
    setLayout()
  }
  
}

// MARK: - Extensions

extension DanalAuthViewController {
  
  // MARK: - Layout Helpers
  
  private func setConfig() {
    view.backgroundColor = .gray050
    [navigationView, titleLabel, phoneImageView, authButton].forEach {
      view.addSubview($0)
    }
  }
  private func setLayout() {
     let guide = self.view.safeAreaLayoutGuide
    navigationView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(guide)
      $0.height.equalTo(56)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom).offset(SignUpConstant.labelTop.adjusted)
      $0.leading.equalTo(guide).offset(SignUpConstant.labelLeading.adjusted)
    }
    phoneImageView.snp.makeConstraints {
      $0.centerX.equalTo(guide)
      $0.centerY.equalTo(guide)
      $0.leading.trailing.equalTo(guide).inset(SignUpConstant.phoneImageWidth.adjusted)
      $0.height.equalTo(SignUpConstant.phoneImageHeight.adjusted)
    }
    authButton.snp.makeConstraints {
      $0.bottom.equalTo(guide).inset(SignUpConstant.buttonBottom.adjusted)
      $0.leading.trailing.equalTo(guide).inset(SignUpConstant.labelTop)
      $0.height.equalTo(SignUpConstant.buttonHeight.adjusted)
    }
  }
}
