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
   let number = UILabel().then {
    $0.text = "1"
    $0.textAlignment = .center
    $0.font = UIFont.font(.pretendardBold, ofSize: 24)
    $0.textColor = .gray900
     
   }
  
  let backImageView = UIImageView().then {
    $0.image = UIImage(named: "ic_backspace")
    $0.contentMode = .scaleAspectFit
    $0.frame.size = CGSize(width: 32, height: 32)
    $0.isHidden = true
    $0.image = $0.image?.withRenderingMode(.alwaysTemplate)
    $0.tintColor = .gray500
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .gray050
    contentView.addSubview(number)
    contentView.addSubview(backImageView)
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
    backImageView.snp.makeConstraints {
      $0.top.trailing.leading.bottom.equalToSuperview().inset(29)
      
    }
  }
  func dataBind(model: SimplePwdContentModel) {
    number.text = model.text
  }
}
