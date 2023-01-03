//
//  ThirdLandingPageViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/04.
//

import UIKit
import SnapKit
import Then

//.adjusted 적용

class ThirdLandingPageViewController: UIViewController {
  
  //MARK: - UI Components
  
  private let logoImageView = UIImageView().then {
    $0.image = UIImage(named: "logoA")
  }
  
  private let mainImageView = UIImageView().then {
    $0.image = UIImage(named: "splash_img03")
  }
  
  private let introLabel = UILabel().then {
    $0.font = UIFont.font(.pretendardBold, ofSize: 24)
    $0.text = "다양한 정보와 \n 혜택을 경험하고"
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  
  private let progressBarImageView = UIImageView().then {
    $0.image = UIImage(named: "LandingBar3")
  }
  
  //MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setConfig()
    setLayout()

  }
}

//MARK: - Extensions

extension ThirdLandingPageViewController {
  private func setConfig() {
    view.backgroundColor = .white
    [logoImageView, mainImageView, introLabel, progressBarImageView].forEach {
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
    
  }
}

