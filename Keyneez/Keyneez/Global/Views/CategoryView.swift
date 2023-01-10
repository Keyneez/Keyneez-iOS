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
  private func setCategoryView() {
    self.backgroundColor = .gray050
    self.layer.cornerRadius = 16
    self.layer.borderWidth = 1.5
    self.layer.borderColor = UIColor.mint500.cgColor
  }
  private let category = UILabel().then {
    $0.text = "문화"
    $0.textColor = UIColor.mint500
    $0.font = UIFont.font(.pretendardBold, ofSize: 14)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setCategoryView()
    setLayout()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CategoryView {
  private func setLayout() {
    self.addSubviews(category)
    category.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
}
