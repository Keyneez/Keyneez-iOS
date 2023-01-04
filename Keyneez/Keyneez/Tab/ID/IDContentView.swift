//
//  IDContentView.swift
//  Keyneez
//
//  Created by Jung peter on 1/4/23.
//

import UIKit

enum IDViewError: LocalizedError {
  
}

private struct Constant {
  static let title: (content: String, fontsize: CGFloat) = ("나의 ID", 24)
  static let description: (content: String, fontsize: CGFloat) = ("온라인 ID로 더 다양한\n활동을 즐겨보세요", 16)
  static let buttonTitle = "발급하기"
  static let buttonSize = (width: 253, height: 44)
  static let cardViewImageName = "cards"
  static let cardViewSize = (width: 240, height: 108)
  static let gapBwtLabels = 12
  static let gapBwtLabelAndView = 32
  static let topOffset = 155
  static let bottomOffset = 246
}

final class IDContentView: NiblessView {
  
  private lazy var cardsImageView: UIImageView = .init().then {
    $0.image = UIImage(named: Constant.cardViewImageName)
  }
  
  private lazy var titleLabel: UILabel = .init().then {
    $0.text = Constant.title.content
    $0.textColor = .gray050
    $0.font = .font(.pretendardBold, ofSize: Constant.title.fontsize)
  }
  
  private lazy var descriptionLabel: UILabel = .init().then {
    $0.text = Constant.description.content
    $0.textAlignment = .center
    $0.numberOfLines = 0
    $0.textColor = .gray400
    $0.font = .font(.pretendardMedium, ofSize: Constant.description.fontsize)
  }
  
  private lazy var issueButton: UIButton = .init().then {
    $0.keyneezButtonStyle(style: .whiteAct, title: Constant.buttonTitle)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    [cardsImageView, titleLabel, descriptionLabel, issueButton].forEach {
      self.addSubview($0)
    }
    setConstraints()
    backgroundColor = .clear
  }

}

// MARK: - Private Method

extension IDContentView {
  
  private func setConstraints() {
    
    [cardsImageView, titleLabel, descriptionLabel, issueButton].forEach {
      setCenterX(with: $0)
    }
    
    cardsImageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Constant.topOffset)
      $0.width.equalTo(Constant.cardViewSize.width)
      $0.height.equalTo(Constant.cardViewSize.height)
      $0.bottom.equalTo(titleLabel.snp.top).offset(-Constant.gapBwtLabelAndView)
    }
    
    titleLabel.snp.makeConstraints {
      $0.bottom.equalTo(descriptionLabel.snp.top).offset(-Constant.gapBwtLabels)
    }
    
    issueButton.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(Constant.gapBwtLabelAndView)
      $0.width.equalTo(Constant.buttonSize.width)
      $0.height.equalTo(Constant.buttonSize.height)
      $0.bottom.equalToSuperview().offset(-Constant.bottomOffset)
    }
    
  }
  
  private func setCenterX(with view: UIView) {
    view.snp.makeConstraints { $0.centerX.equalToSuperview() }
  }

}
