//
//  HashTagCollectionViewCell.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/09.
//

import UIKit
import Then

class HashTagCollectionViewCell: UICollectionViewCell {
  
  private let hashTagImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
  }
  private let hashTagLabel = UILabel().then {
    $0.font = .font(.pretendardMedium, ofSize: 16)
    $0.textColor = .gray900
  }
  let indexView = UIView().then {
    $0.backgroundColor = .gray050
    $0.layer.cornerRadius = 10
    $0.isHidden = true
  }
  let indexTextLabel = UILabel().then {
    $0.font = .font(.pretendardBold, ofSize: 10)
    $0.textColor = .gray900
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setConfig()
    setLayout()
  }
  
  required
  init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func selectView(index: Int) {
    contentView.backgroundColor = .gray900
    hashTagLabel.textColor = .gray050
    indexView.isHidden = false
    indexTextLabel.text = String(index + 1)
  }
  func unSelectiView() {
    contentView.backgroundColor = .gray100
    hashTagLabel.textColor = .gray900
    indexView.isHidden = true
  }
  func changeIndexLabel(index: Int) {
        indexTextLabel.text = String(index + 1)
    }
}

extension HashTagCollectionViewCell {
  
  private func setConfig() {
    [hashTagImageView, hashTagLabel, indexView].forEach {
      contentView.addSubview($0)
    }
    indexView.addSubview(indexTextLabel)
    contentView.layer.cornerRadius = 8
    contentView.backgroundColor = .gray100
  }
  private func setLayout() {
    hashTagImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(12)
      $0.centerY.equalToSuperview()
      $0.width.equalTo(41)
      $0.height.equalTo(35)
    }
    hashTagLabel.snp.makeConstraints {
      $0.trailing.bottom.equalToSuperview().inset(10)
    }
    indexView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.trailing.equalTo(hashTagLabel)
      $0.width.height.equalTo(17)
      
    }
    indexTextLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
  func dataBind(model: HashTagContentModel) {
    hashTagImageView.image = UIImage(named: model.image)
    hashTagLabel.text = model.text
  }
}
