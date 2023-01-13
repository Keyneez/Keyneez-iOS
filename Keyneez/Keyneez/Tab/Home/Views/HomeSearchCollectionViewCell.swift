//
//  HomeSearchCollectionViewCell.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/09.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class HomeSearchCollectionViewCell: UICollectionViewCell {
  static let identifier = "HomeSearchCollectionViewCell"
  let repository: ContentRepository = KeyneezContentRepository()
  var searchContentId: Int = -1
  
  private let backgroundImageView: UIImageView = .init().then {
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  private let opacityView: UIView = .init().then {
    $0.backgroundColor = .gray900
    $0.layer.opacity = 0.2
    $0.layer.cornerRadius = 4
  }
  private let dateLabel: UILabel = .init().then {
    $0.font = .font(.pretendardSemiBold, ofSize: 14)
    $0.textColor = .gray050
  }
  private let titleLabel: UILabel = .init().then {
    $0.font = .font(.pretendardSemiBold, ofSize: 24)
    $0.textColor = .gray050
    $0.numberOfLines = 3
    $0.textAlignment = .center
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
    contentView.addSubviews(backgroundImageView)
    contentView.layer.cornerRadius = 4
    backgroundImageView.layer.cornerRadius = 4
    backgroundImageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    backgroundImageView.addSubviews(opacityView, dateLabel, titleLabel, likeButton)
    opacityView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    dateLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(19)
      $0.centerX.equalToSuperview()
    }
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
    likeButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(24)
      $0.centerX.equalToSuperview()
    }
  }
  func bindHomeSearchData(model: SearchContentResponseDto) {
    titleLabel.text = model.contentTitle
    dateLabel.text = setDateLabel(startAt: model.startAt, endAt: model.endAt)
    searchContentId = model.contentKey
    likeButton.isSelected = model.liked
    guard let url = model.contentImg else { return }
    backgroundImageView.setImage(url: url)
    // TODO: 이미지, 버튼 값 변경
  }
  func bindLikedContentData(model: MyLikedContentResponseDto) {
    titleLabel.text = model.contentTitle
    dateLabel.text = setDateLabel(startAt: model.startAt, endAt: model.endAt)
    likeButton.isHidden = true
    guard let url = model.contentImg else { return }
    backgroundImageView.setImage(url: url)
    // TODO: 이미지, 버튼 값 변경
  }
  @objc
  private func touchUpLikeButton() {
    likeButton.isSelected = !likeButton.isSelected
    print("클릭했다")
      guard let token = UserSession.shared.accessToken else { return }
      repository.postLikeContent(token: token, contentId: searchContentId) { result in
        print(result)
    }
  }
  private func getDate(fullDate: String) -> String {
    let monthIndex = fullDate.index(fullDate.endIndex, offsetBy: -4)
    let dayIndex = fullDate.index(fullDate.endIndex, offsetBy: -2)
    let month = String(fullDate[monthIndex..<dayIndex])
    let day = (fullDate[dayIndex...])
    return month + "." + day
  }
  private func setDateLabel(startAt: String?, endAt: String?) -> String {
    if startAt == nil || endAt == nil { return "2023 ~ " }
    if startAt!.isEmpty || endAt!.isEmpty { return "2023 ~ " }
    return getDate(fullDate: startAt!) + " ~ " + getDate(fullDate: endAt!)
  }
}
