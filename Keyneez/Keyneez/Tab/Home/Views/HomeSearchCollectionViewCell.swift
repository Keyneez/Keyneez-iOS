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
  
  // MARK: - Modern Collection View
  var searchContent: HomeContentModel? {
    didSet {
      self.bindHomeSearchData(model: searchContent!)
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setLayout()
    setTitleLabel()
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
      $0.bottom.equalToSuperview().inset(24)
      $0.centerX.equalToSuperview()
    }
  }
  func bindHomeSearchData(model: HomeContentModel) {
    dateLabel.text = setDateLabel(model: model)
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
  private func setDateLabel(model: HomeContentModel) -> String {
    if model.startAt.isEmpty || model.endAt.isEmpty { return "2023 ~ " }
    return getDate(fullDate: model.startAt) + " ~ " + getDate(fullDate: model.endAt)
  }
  
//  private func setTitleLabel() -> String {
//    let title = "청소년 영화관 할인" // 나 새콤 - 달콤 좋아아주 ["나", "새콤", "달콤", "좋아아주"]
//    let separeteString = title.components(separatedBy: " ")
//    var results: [String] = []
//    var resultString = ""
//    for words in separeteString {
//      if separeteString.lastIndex(of: words) == separeteString.count - 1 {
//        results.append(resultString)
//        return title
//      }
//      if resultString.count < 6 {
//        if resultString.count + words.count <= 6 {
//          resultString += words
//          resultString += " "
//        } else {
//          results.append(resultString)
//          resultString = words
//        }
//        // 붙인 글자가 7자 이상이면 넘어가고, 6자 이하면 붙이기
//      } else {
//        if words.count > 6 {
//          let startIndex = words.index(words.startIndex, offsetBy: 0)
//          let maxIndex = words.index(words.startIndex, offsetBy: 6)
//          let nextIndex = words.index(words.startIndex, offsetBy: 7)
//          results.append(String(words[startIndex ... maxIndex]))
//          resultString += String(words[nextIndex ... words.endIndex])
//        }
//        // 6번째까지 잘라서 results 에 넣고, 그 뒤를 resultString으로 넘기기
//      }
//      print(results)
//      print(resultString)
//      // index 넘어가면 글자수 하나 + -> 6자리까지 허용.. V
//      // results 에 계속 붙여. 인덱스 넘어갈 때마다 results 글자수 검사 v
//      // results 가 7자리 이상이면 새로운 문자열 만들기
//      // resultString 사이 \n 추가
//    }
//    return title
//  }
}
