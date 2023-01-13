//
//  CategoryView.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/09.
//

import UIKit
import Then
import SnapKit

final class CategoryView: NiblessView {
  
  private func setCategoryView() {
    self.backgroundColor = .gray050
    self.layer.cornerRadius = 16
    self.layer.borderWidth = 1.5
    self.layer.borderColor = UIColor.mint500.cgColor
  }
  
  private let categoryLabel = UILabel().then {
    $0.text = "문화"
    $0.textColor = .mint500
    $0.font = .font(.pretendardBold, ofSize: 14)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setCategoryView()
    setLayout()
  }

}

extension CategoryView {
  private func setLayout() {
    self.addSubviews(categoryLabel)
    categoryLabel.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
  func setCategory(with category: String) {
    switch(category) {
    case "진로" :
      categoryLabel.text = "진로"
      categoryLabel.textColor = .green600
      self.layer.borderColor = UIColor.green600.cgColor
    case "봉사":
      categoryLabel.text = "봉사"
      categoryLabel.textColor = .purple500
      self.layer.borderColor = UIColor.purple500.cgColor
    case "여행":
      categoryLabel.text = "여행"
      categoryLabel.textColor = .pink500
      self.layer.borderColor = UIColor.pink500.cgColor
    case "경제":
      categoryLabel.text = "경제"
      categoryLabel.textColor = .red500
      self.layer.borderColor = UIColor.red500.cgColor
    default:
      break
    }
  }
}
