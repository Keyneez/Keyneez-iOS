//
//  FourthLandingPageViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/04.
//

import UIKit

class FourthLandingPageViewController: UIViewController {
  
  //MARK: - UI Components
  
  private let logoImageView = UIImageView().then {
    $0.image = UIImage(named: "logoA")
  }
  
  private let mainImageView = UIImageView().then {
    $0.image = UIImage(named: "splash_img04")
  }
  
  private let introLabel = UILabel().then {
    $0.font = UIFont.font(.pretendardBold, ofSize: 24)
    $0.text = "나만의 개성이 담긴 \n ID를 만들 수 있도록!"
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  
  private let progressBarImageView = UIImageView().then {
    $0.image = UIImage(named: "LandingBar4")
  }
  
  private lazy var signUpButton = UIButton().then {
    $0.keyneezButtonStyle(style: .whiteAct, title: "회원가입")
  }
  
  private lazy var signInButton = UIButton().then {
    $0.keyneezButtonStyle(style: .blackAct, title: "로그인")
  }
  
  //MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setConfig()
    setLayout()

  }
  
}

//MARK: - Extensions

extension FourthLandingPageViewController {
  private func setConfig() {
    view.backgroundColor = .white
    [logoImageView, mainImageView, introLabel, progressBarImageView, signUpButton, signInButton].forEach {
      view.addSubview($0)
    }
  }
  
  //MARK: - Layout Helpers
  
  private func setLayout() {
    
    logoImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(56)
      $0.width.equalTo(130.29)
      $0.height.equalTo(48)
    }
    mainImageView.snp.makeConstraints {
      $0.top.equalTo(logoImageView.snp.bottom).offset(40)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(244)
    }
    introLabel.snp.makeConstraints {
      $0.top.equalTo(mainImageView.snp.bottom).offset(32)
      $0.centerX.equalToSuperview()
    }
    progressBarImageView.snp.makeConstraints {
      $0.top.equalTo(introLabel.snp.bottom).offset(32)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(72)
      $0.height.equalTo(12)
    }
    signUpButton.snp.makeConstraints {
      $0.top.equalTo(progressBarImageView.snp.bottom).offset(90)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
      $0.height.equalTo(48)
    }
    signInButton.snp.makeConstraints {
      $0.top.equalTo(signUpButton.snp.bottom).offset(12)
      $0.leading.trailing.equalTo(signUpButton)
      $0.height.equalTo(signUpButton)
    }
  }
}


