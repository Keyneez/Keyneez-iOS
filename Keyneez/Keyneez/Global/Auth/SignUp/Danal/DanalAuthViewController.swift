//
//  DanalAuthViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/07.
//

import UIKit
import Then

final class DanalAuthViewController: NiblessViewController, NavigationBarProtocol {

  // MARK: - UI Components
  
 lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .flexibleBox]).build()
  var contentView = UIView()
  
  private lazy var backButton: UIButton = .init(primaryAction: touchUpBackButton).then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback_search"), for: .normal)
  }
  private lazy var touchUpBackButton: UIAction = .init(handler: { _ in
    self.navigationController?.popViewController(animated: true)
  })
  
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
    $0.addTarget(self, action: #selector(touchUpNextVC), for: .touchUpInside)
  }
  
  @objc
  private func touchUpNextVC() {
    pushToNextVC(VC:DanalAuthSuccessViewController())
  }
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addNavigationViewToSubview()
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
      contentView.addSubview($0)
    }
  }
  private func setLayout() {
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(SignUpConstant.labelTop.adjusted)
      $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(SignUpConstant.labelLeading.adjusted)
    }
    phoneImageView.snp.makeConstraints {
      $0.centerX.equalTo(self.view.safeAreaLayoutGuide)
      $0.centerY.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(SignUpConstant.phoneImageWidth.adjusted)
      $0.height.equalTo(SignUpConstant.phoneImageHeight.adjusted)
    }
    authButton.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(SignUpConstant.buttonBottom.adjusted)
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(SignUpConstant.labelTop)
      $0.height.equalTo(SignUpConstant.buttonHeight.adjusted)
    }
  }
}
