//
//  BenefitCollectionViewCell.swift
//  Keyneez
//
//  Created by Jung peter on 1/5/23.
//

import UIKit

class BenefitCollectionViewCell: UICollectionViewCell {
  
  private lazy var titleLabel: UILabel = .init().then {
    $0.textColor = .gray900
    $0.numberOfLines = 0
    $0.textAlignment = .left
    $0.font = .font(.pretendardBold, ofSize: 16)
  }
  
  private lazy var iconImageView: UIImageView = .init()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setbackgroundColor()
    addSubview()
    setContraint()
    setRadius()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension BenefitCollectionViewCell {
  
  private func setbackgroundColor() {
    contentView.backgroundColor = .gray100
  }
  
  private func setRadius() {
    contentView.layer.cornerRadius = 12
    contentView.layer.masksToBounds = true
  }
  
  private func addSubview() {
    [titleLabel, iconImageView].forEach { self.contentView.addSubview($0) }
  }
  
  private func setContraint() {
    titleLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(14)
    }
    
    iconImageView.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-14.7)
      $0.trailing.equalToSuperview().offset(-18)
    }
  }
  
}

extension BenefitCollectionViewCell {
  internal func setData(with info: (title: String, imageName: String)) {
    titleLabel.text = info.title
    iconImageView.image = UIImage(named: info.imageName)!
  }
}
