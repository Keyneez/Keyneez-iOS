//
//  HomeSearchCollectionViewCell.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/09.
//

import UIKit
import SnapKit
import Then

final class HomeSearchCollectionViewCell: UICollectionViewCell {
  static let identifier = "HomeSearchCollectionViewCell"
  
  private let backgroundImageView: UIImageView = .init()
  private let dateLabel: UILabel = .init().then {
    $0.font = .font(.pretendardSemiBold, ofSize: 14)
    $0.textColor = .gray050
  }
  private let titleLabel: UILabel = .init().then {
    $0.font = .font(.pretendardSemiBold, ofSize: 24)
    $0.textColor = .gray050
  }
  private lazy var likeButton: UIButton = .init().then {
    $0.setImage(UIImage(named: "ic_favorite_line__search"), for: .normal)
    $0.setImage(UIImage(named: "ic_favorite_search"), for: .selected)
    $0.addTarget(self, action: #selector(touchUpLikeButton), for: .touchUpInside)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HomeSearchCollectionViewCell {
  private func setLayout() {
    contentView.backgroundColor = .gray900
    contentView.layer.cornerRadius = 4
    contentView.addSubviews(dateLabel, titleLabel, likeButton)
    dateLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(19)
      $0.centerX.equalToSuperview()
    }
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(85)
      $0.centerX.equalToSuperview()
    }
    likeButton.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(49)
      $0.centerX.equalToSuperview()
    }
  }
  func bindHomeSearchData(model: HomeSearchModel) {
    dateLabel.text = setDateLabel(model: model) // 이 부분 date 형식 변경
    titleLabel.text = model.contentTitle
  }
  @objc
  private func touchUpLikeButton() {
    print(likeButton.state)
  }
  private func getDate(fullDate: String) -> String {
    let monthIndex = fullDate.index(fullDate.endIndex, offsetBy: -4)
    let dayIndex = fullDate.index(fullDate.endIndex, offsetBy: -2)
    let month = String(fullDate[monthIndex..<dayIndex])
    let day = (fullDate[dayIndex...])
    return month + "." + day
  }
  private func setDateLabel(model: HomeSearchModel) -> String {
    if model.startAt.isEmpty || model.endAt.isEmpty { return "" }
    return getDate(fullDate: model.startAt) + " ~ " + getDate(fullDate: model.endAt)
  }
}
