//
//  JellyProductViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/09.
//

import UIKit
import SnapKit
import Then

class JellyProductView: NiblessView {
  
  // MARK: - UI Components
  
  private let titleLabel: UILabel = .init().then {
    $0.text = "민지님의 젤리는"
    $0.font = .font(.pretendardSemiBold, ofSize: 20)
    $0.textColor = .gray500
  }
  private let subTitleLabel: UILabel = .init().then {
    $0.text = "호기심 가득 문화인"
    $0.font = UIFont.font(.pretendardBold, ofSize: 28)
    $0.textColor = .gray900
  }
  private lazy var detailButton: UIButton = .init().then {
    $0.setImage(UIImage(named: "ic_allowback_rignt"), for: .normal)
    $0.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
  }
  
  private let detailStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.isUserInteractionEnabled = true
    $0.alignment = .leading
    $0.spacing = 0
  }
  private let backImageView: UIImageView = .init().then {
    $0.image = UIImage(named: "red")
  }
  
  private lazy var jellyImageView: UIImageView = .init().then {
    $0.image = UIImage(named: "mintJelly")
  }
  
  private let itemLabel: UILabel = .init().then {
    $0.text = "나의 아이템"
    $0.font = .font(.pretendardBold, ofSize: 14)
    $0.textColor = .gray900
  }
  private let itemCountLabel: UILabel = .init().then {
    $0.text = "6"
    $0.textColor = .mint500
    $0.font = .font(.pretendardBold, ofSize: 14)
  }
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.isScrollEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
//    collectionView.delegate = self
//    collectionView.dataSource = self
    return collectionView
  }()
  
  private lazy var startButton: UIButton = .init(primaryAction: actions.touchNextButton()).then {
    $0.keyneezButtonStyle(style: .blackAct, title: "키니즈 시작하기")
  }

  private var actions : SignUpActions
  
  init(frame: CGRect, actions: SignUpActions) {
    self.actions = actions
    super.init(frame: frame)
    setConfig()
    setLayout()
  }
}

// MARK: - Extensions

extension JellyProductView {
  
  // MARK: - Layout Helpers
  
  private func setConfig() {
    self.backgroundColor = .gray050
    [titleLabel,detailStackView, backImageView, itemLabel, itemCountLabel, collectionView].forEach {
      self.addSubview($0)
    }
    [subTitleLabel,detailButton].forEach {
      detailStackView.addSubview($0)
    }
    backImageView.addSubview(jellyImageView)
  }
  private func setLayout() {
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(SignUpConstant.labelTop)
      $0.leading.equalTo(SignUpConstant.guide).offset(SignUpConstant.labelLeading)
    }
    detailStackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel).offset(8)
      $0.leading.equalTo(titleLabel)
    }
    backImageView.snp.makeConstraints {
      $0.top.equalTo(detailButton.snp.bottom).offset(50)
      $0.leading.trailing.equalToSuperview().inset(32)
      $0.height.equalTo(290)
    }
    jellyImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(14)
      $0.leading.trailing.equalToSuperview().inset(50)
      $0.bottom.equalToSuperview().inset(36)
    }
    itemLabel.snp.makeConstraints {
      $0.top.equalTo(backImageView.snp.bottom).offset(28)
      $0.leading.equalToSuperview().offset(16)
    }
    itemCountLabel.snp.makeConstraints {
      $0.top.bottom.equalTo(itemLabel)
      $0.leading.equalTo(itemLabel.snp.trailing)
    }
    collectionView.snp.makeConstraints {
      $0.top.equalTo(itemLabel.snp.bottom).offset(12)
      $0.leading.equalTo(itemLabel)
      $0.trailing.equalToSuperview()
      $0.bottom.equalTo(88)
    }
    startButton.snp.makeConstraints {
      $0.bottom.equalTo(SignUpConstant.guide).inset(SignUpConstant.buttonBottom.adjusted)
      $0.leading.trailing.equalTo(SignUpConstant.guide).inset(SignUpConstant.labelTop)
      $0.height.equalTo(SignUpConstant.buttonHeight.adjusted)
    }
  }
}
extension JellyProductView: UICollectionViewDelegateFlowLayout {
  
}

