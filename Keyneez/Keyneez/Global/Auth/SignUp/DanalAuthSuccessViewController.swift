//
//  DanalAuthSuccessViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/07.
//

import UIKit
import SnapKit
import Then

// MARK: - 네비게이션 바 만들기 !!

class DanalAuthSuccessViewController: UIViewController {
  
  // MARK: - UI Components
  private let titleLabel = UILabel().then {
    $0.text = "만나서 반가워요!\n이제 민지님의 젤리를\n만들어 볼까요?"
    $0.font = UIFont.font(.pretendardBold, ofSize: 24)
    $0.numberOfLines = 0
  }
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setConfig()
    setLayout()
  }
}

// MARK: - Extensions

extension DanalAuthSuccessViewController {
  
  // MARK: - Layout Helpers
  
  private func setConfig() {
    view.backgroundColor = .gray050
    [titleLabel].forEach {
      view.addSubview($0)
    }
  }
  private func setLayout() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(SignUpConstant.labelTop.adjusted)
      $0.leading.equalToSuperview().offset(SignUpConstant.labelLeading.adjusted)
    }
  }
}
