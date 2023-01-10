//
//  SimplePwdCollectionViewCell.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/11.
//

import UIKit
import SnapKit
import Then

class SimplePwdCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "SimplePwdCollectionViewCell"
   let number = UILabel().then {
    $0.text = "1"
    $0.textAlignment = .center
    $0.font = UIFont.font(.pretendardBold, ofSize: 24)
    $0.textColor = .gray900
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .gray050
    contentView.addSubview(number)
    setLayout()
  }
  
  required
  init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SimplePwdCollectionViewCell {
  private func setLayout() {
    number.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
  
  func dataBind(model: SimplePwdContentModel) {
    number.text = model.text
  }
}
