//
//  PropensityTagCustomView.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/08.
//

import UIKit
import Then

class PropensityTagCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Identifier
  static let identifier = "PropensityTagCollectionViewCell"
  
  // MARK: - UI Components
  
   let textLabel = UILabel().then {
    $0.font = .font(.pretendardMedium, ofSize: 24)
    $0.textColor = .gray400
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

extension PropensityTagCollectionViewCell {
  
  private func setConfig() {
    contentView.backgroundColor = .gray100
    contentView.addSubview(textLabel)
    contentView.setRound([.bottomLeft, .bottomRight, .topRight], radius: 24)
    // 왼쪽 위 모서리 둥글게
    contentView.layer.cornerRadius = 4
    contentView.layer.maskedCorners = CACornerMask.layerMinXMinYCorner
  }
  
  private func setLayout() {
    
    textLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
  }
  func dataBind(model: PropensityTagContentModel) {
    textLabel.text = model.text
  }
}
