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
  var homeContentID = -1
  // MARK: - UI Components

  private let shadowView = UIView().then {
    $0.layer.masksToBounds = false
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray100.cgColor
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.layer.shadowOffset = CGSize(width: 0, height: 2)
    $0.layer.shadowOpacity = 1
    $0.layer.shadowRadius = 4
  }
  private let containerView = UIView().then {
    $0.backgroundColor = UIColor.gray050
    $0.layer.cornerRadius = 4
  }
  private let contentImageView = UIImageView().then {
    $0.layer.cornerRadius = 4
    $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
  }
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
  private let categoryView = CategoryView()
  private lazy var likeButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_favorite_home_line"), for: .normal)
    $0.setImage(UIImage(named: "ic_favorite_home_filled"), for: .selected)
    $0.addTarget(self, action: #selector(touchUpLikeButton), for: .touchUpInside)
  }
  private let cardImageView: UIImageView = .init().then {
    $0.image = UIImage(named: "card_blue_home")
  }
  private let contentTitle = UILabel().then {
    $0.font = UIFont.font(.pretendardBold, ofSize: 28)
    $0.textColor = UIColor.gray900
  }
  private let contentIntroduction = UILabel().then {
    $0.font = UIFont.font(.pretendardMedium, ofSize: 14)
    $0.textColor = UIColor.gray600
  }
  // MARK: - Life Cycle

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
    contentView.addSubviews(shadowView, containerView)
    containerView.addSubviews(
      contentImageView,
      dateView,
      likeButton,
      categoryView,
      contentTitle,
      contentIntroduction,
      cardImageView
    )
    dateView.addSubviews(dateLabel)

    shadowView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    containerView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
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
    contentTitle.snp.makeConstraints {
      $0.top.equalTo(categoryView.snp.bottom).offset(12)
      $0.leading.trailing.equalToSuperview().inset(21)
    }
    contentIntroduction.snp.makeConstraints {
      $0.top.equalTo(contentTitle.snp.bottom).offset(4)
      $0.leading.trailing.equalTo(contentTitle)
    }
    cardImageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(207)
      $0.trailing.equalToSuperview().inset(28)
      $0.width.equalTo(64)
      $0.height.equalTo(72)
    }
    contentImageView.backgroundColor = .gray400
  }
  
  func bindHomeData(model: HomeContentResponseDto) {
    homeContentID = model.contentKey
//    contentImageView.image = UIImage(named: model.contentImage)
    dateLabel.text = setDateLabel(model: model)
//    category.text = model.categoty[0]
    contentTitle.text = setTitle(fullTitle: model.contentTitle)
    contentIntroduction.text = model.introduction
  }
  private func setTitle(fullTitle: String) -> String {
    guard let title = fullTitle as? String else {return ""}
        return title.replacingOccurrences(of: "\n", with: " ")
  }
  private func getDate(fullDate: String) -> String {
    let monthIndex = fullDate.index(fullDate.endIndex, offsetBy: -4)
    let dayIndex = fullDate.index(fullDate.endIndex, offsetBy: -2)
    let month = String(fullDate[monthIndex..<dayIndex])
    let day = (fullDate[dayIndex...])
    return month + "." + day
  }
  private func setDateLabel(model: HomeContentResponseDto) -> String {
    if model.startAt == nil || model.endAt == nil { dateView.isHidden = true; return "" }
    if model.startAt!.isEmpty || model.endAt!.isEmpty { dateView.isHidden = true; return "" }
    return getDate(fullDate: model.startAt!) + " ~ " + getDate(fullDate: model.endAt!)
  }
  @objc
  private func touchUpLikeButton() {
    likeButton.isSelected = !likeButton.isSelected
  }
}
