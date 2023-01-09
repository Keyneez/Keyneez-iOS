//
//  JellyProductCollectionViewCell.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/09.
//

import UIKit
import Then

class JellyProductCollectionViewCell: UICollectionViewCell{
  
  private let imageContainerView = UIView().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.mint500.cgColor
    $0.layer.cornerRadius = 3
  }
  
  private let imageView = UIImageView().then {
    $0.image = UIImage(named: "mintJelly")
  }
    
}

extension JellyProductCollectionViewCell {
  private func setConfig() {
    contentView.addSubview(imageContainerView)
    imageContainerView.addSubview(imageView)
  }
  private func setLayout() {
    imageContainerView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
      $0.width.height.equalTo(88)
    }
    imageView.snp.makeConstraints {
      $0.top.bottom.leading.trailing.equalToSuperview().inset(12)
    }
  }
}
