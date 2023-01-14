//
//  DanalAuthSuccessViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/07.
//

import UIKit
import SnapKit
import Then

// TODO: 3초 있다가 자동 화면 넘기기 구현

class DanalAuthSuccessViewController: NiblessViewController, NavigationBarProtocol {
  
  // MARK: - UI Components
  
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.flexibleBox]).build()
   var contentView = UIView()
  
  private let titleLabel = UILabel().then {
    $0.text = "만나서 반가워요!\n이제 김민지님의 젤리를\n만들어 볼까요?"
    $0.font = UIFont.font(.pretendardBold, ofSize: 24)
    $0.numberOfLines = 0
  }
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setConfig()
    setLayout()
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
      self.pushToNextVC(VC: JellyMakeViewController())
    }
  }
}

// MARK: - Extensions

extension DanalAuthSuccessViewController {
  
  // MARK: - Layout Helpers
  
  private func setConfig() {
    view.backgroundColor = .gray050
    [navigationView, titleLabel].forEach {
      view.addSubview($0)
    }
  }
  private func setLayout() {
    
    navigationView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(56)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom).offset(SignUpConstant.labelTop.adjusted)
      $0.leading.equalToSuperview().offset(SignUpConstant.labelLeading.adjusted)
    }
  }
}
