//
//  HomeContentCollectionViewCell.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/06.
//

import UIKit
import Then
import SnapKit

final class HomeContentCollectionViewCell: UICollectionViewCell {
  static let identifier = "HomeContentCollectionViewCell"
  
  // MARK: - UI Components
  private let contentImageView = UIImageView()
  private let dateView = UIView().then {
    $0.backgroundColor = UIColor.gray050.withAlphaComponent(0.8)
    $0.layer.cornerRadius = 16
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray050.cgColor
  }
  private let dateLabel = UILabel().then {
    $0.font = UIFont.font(.pretendardSemiBold, ofSize: 12)
    $0.textColor = UIColor.gray900
  }
  private let categoryView = UIView().then {
    $0.backgroundColor = .clear
    $0.layer.cornerRadius = 20
    $0.layer.borderWidth = 1.5
    $0.layer.borderColor = UIColor.mint400.cgColor
  }
  private let category = UILabel().then {
    $0.textColor = UIColor.mint400
    $0.font = UIFont.font(.pretendardBold, ofSize: 14)
  }
  private let likeButton = UIButton().then {
    $0.setImage(UIImage(named: "white_like_empty"), for: .normal)
  }
  private let cardImageView = UIImageView()
  private let contentTitle = UILabel().then {
    $0.font = UIFont.font(.pretendardBold, ofSize: 28)
    $0.textColor = UIColor.gray900
  }
  private let contentIntroduction = UILabel().then {
    $0.font = UIFont.font(.pretendardMedium, ofSize: 14)
    $0.textColor = UIColor.gray600
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HomeContentCollectionViewCell {
  private func setLayout() {
    backgroundColor = .clear
    contentView.addSubviews(contentImageView, dateView, likeButton, categoryView, contentTitle, contentIntroduction)
    dateView.addSubviews(dateLabel)
    categoryView.addSubviews(category)
    contentImageView.backgroundColor = .yellow
    contentImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(240)
    }
    dateView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(26)
      $0.leading.equalToSuperview().inset(21)
      $0.width.equalTo(102)
      $0.height.equalTo(30)
    }
    dateLabel.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    likeButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(26)
      $0.trailing.equalToSuperview().inset(24)
      $0.width.height.equalTo(32)
    }
    categoryView.snp.makeConstraints {
      $0.top.equalTo(contentImageView.snp.bottom).offset(27)
      $0.leading.equalTo(dateView)
      $0.width.equalTo(49)
      $0.height.equalTo(33)
    }
    category.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    contentTitle.snp.makeConstraints {
      $0.top.equalTo(category.snp.bottom).offset(12)
      $0.leading.equalTo(categoryView)
    }
    contentIntroduction.snp.makeConstraints {
      $0.top.equalTo(contentTitle.snp.bottom).offset(4)
      $0.leading.equalTo(contentTitle)
    }
  }
  
  func dataBind(model: HomeContentModel) {
    contentImageView.image = UIImage(named: model.contentImage)
    dateLabel.text = model.start_at + " ~ " + model.end_at
    category.text = model.categoty[0]
    contentTitle.text = model.contentTitle
    contentIntroduction.text = model.introduction
  }
}
