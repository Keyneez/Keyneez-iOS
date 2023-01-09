//
//  JellyProductCollectionViewCell.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/09.
//

import UIKit
import SnapKit
import Then

class JellyProductCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "JellyProductCollectionViewCell"
  
   let imageContainerView = UIView().then {
    $0.backgroundColor = .gray100
    $0.layer.cornerRadius = 8
  }
  
   let imageView = UIImageView().then {
    $0.image = UIImage(named: "mintJelly")
    $0.contentMode = .scaleAspectFit
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setConfig()
    setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension JellyProductCollectionViewCell {
  private func setConfig() {
    contentView.backgroundColor = .gray100
    contentView.layer.cornerRadius = 8
    contentView.addSubview(imageContainerView)
    imageContainerView.addSubview(imageView)
  }
  private func setLayout() {
    imageContainerView.snp.makeConstraints {
      $0.top.leading.equalToSuperview()
      $0.width.height.equalTo(88)
    }
    imageView.snp.makeConstraints {
      $0.top.bottom.leading.trailing.equalToSuperview().inset(12)
    }
  }
  
  func dataBind(model: JellyContentModel) {
    imageView.image = UIImage(named: model.image)
  }
}
