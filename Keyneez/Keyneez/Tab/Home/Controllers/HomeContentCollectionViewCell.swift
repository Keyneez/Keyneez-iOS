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
  private let dateView = UIView()
  private let dateLabel = UILabel().then {
    $0.font = UIFont(name: "pretendardSemiBold", size: 12)
    $0.textColor = UIColor.gray900
  }
  private let categoryView = UIView()
  private let category = UILabel()
  private let likeButton = UIButton()
  private let cardImageView = UIImageView()
  private let contentTitle = UILabel()
  private let contentIntroduction = UILabel()
  
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
    contentView.backgroundColor = UIColor.systemBlue
    contentView.addSubviews(contentImageView, dateView, categoryView, dateLabel)
    contentImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(240)
    }
    dateLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(35)
      $0.leading.equalToSuperview().inset(36)
    }
  }
  
  func dataBind(model: HomeContentModel) {
    contentImageView.image = UIImage(named: model.contentImage)
    dateLabel.text = model.start_at + " ~ " + model.end_at
  }
}
