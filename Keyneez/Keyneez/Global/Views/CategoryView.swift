//
//  CategoryView.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/09.
//

import UIKit
import Then
import SnapKit

final class CategoryView: UIView {
  private let categoryView = UIView().then {
    $0.backgroundColor = .clear
    $0.layer.cornerRadius = 16
    $0.layer.borderWidth = 1.5
    $0.layer.borderColor = UIColor.mint500.cgColor
  }
  private let category = UILabel().then {
    $0.text = "문화"
    $0.textColor = UIColor.mint500
    $0.font = UIFont.font(.pretendardBold, ofSize: 14)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setLayout()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CategoryView {
  private func setLayout() {
    self.addSubviews(categoryView)
    categoryView.addSubviews(category)
    categoryView.snp.makeConstraints {
      $0.width.equalTo(49)
      $0.height.equalTo(33)
    }
    category.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
}
