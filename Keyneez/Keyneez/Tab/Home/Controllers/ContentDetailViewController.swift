//
//  ContentDetailViewController.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/09.
//

import UIKit
import Then
import SnapKit

final class ContentDetailViewController: NiblessViewController, NavigationBarProtocol {
  
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .flexibleBox, .iconButton(with: shareButton), .sizedBox(width: 16), .iconButton(with: likeButton)]).build()
  private lazy var backButton: UIButton = .init(primaryAction: touchUpBackButton).then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback_search"), for: .normal)
  }
  private lazy var shareButton: UIButton = .init(primaryAction: touchUpShareButton).then {
    $0.setBackgroundImage(UIImage(named: "ic_share3"), for: .normal)
  }
  private lazy var likeButton: UIButton = .init(primaryAction: touchUpLikeButton).then {
    $0.setBackgroundImage(UIImage(named: "Property 1=line"), for: .normal)
  }
  private lazy var touchUpBackButton: UIAction = .init(handler: { _ in
    self.navigationController?.popViewController(animated: true)
  })
  private lazy var touchUpShareButton: UIAction = .init(handler: { _ in
    print("touch up ShareButton")
  })
  private lazy var touchUpLikeButton: UIAction = .init(handler: { _ in
    print("touch up LikeButton")
  })
  var contentView: UIView = .init()
  private let scrollView: UIScrollView = .init().then {
    $0.showsVerticalScrollIndicator = false
  }
  private let contentContainerView: UIView = .init()
  private let contentTitle: UILabel = .init().then {
    $0.font = .font(.pretendardBold, ofSize: 24)
    $0.textColor = .gray900
  }
  private let categoryCardImageView: UIImageView = .init().then {
    $0.image = UIImage(named: "card_black_contentDetail")
  }
  private let locationBasicLabel: UILabel = .init().then {
    $0.text = "위치"
    $0.font = .font(.pretendardBold, ofSize: 14)
    $0.textColor = .gray900
  }
  private let locationLabel: UILabel = .init().then {
    $0.text = "서울 킨텍스"
    $0.font = .font(.pretendardMedium, ofSize: 14)
    $0.textColor = .gray900
  }
  private let durationBasicLabel: UILabel = .init().then {
    $0.text = "기간"
    $0.font = .font(.pretendardBold, ofSize: 14)
    $0.textColor = .gray900
  }
  private let durationLabel: UILabel = .init().then {
    $0.text = "22.11.24-22.12.31"
    $0.font = .font(.pretendardMedium, ofSize: 14)
    $0.textColor = .gray900
  }
  private let contentImageView: UIImageView = .init().then {
    $0.backgroundColor = .gray500
  }
  private lazy var urlRoundButton: UIButton = .init().then {
    $0.layer.cornerRadius = 17
    $0.backgroundColor = .black
    $0.addTarget(self, action: #selector(touchUpUrlRoundButton), for: .touchUpInside)
  }
  private let urlButtonLabel: UILabel = .init().then {
    $0.text = "사이트 바로가기"
    $0.font = .font(.pretendardMedium, ofSize: 14)
    $0.textColor = .gray050
  }
  private let urlButtonImage: UIImageView = .init(image: UIImage(named: "ic_dropdown_right"))
  private let contentInfoLabel: UILabel = .init().then {
    $0.text = "어찌구저찌구 활동 설명입니다."
    $0.font = .font(.pretendardMedium, ofSize: 14)
    $0.textColor = .gray900
  }
  private let benefitBasicLabel: UILabel = .init().then {
    $0.text = "청소년 혜택"
    $0.font = .font(.pretendardBold, ofSize: 18)
    $0.textColor = .gray900
  }
  private lazy var firstSepareteLine = makeLine()
  private let benefitLabel: UILabel = .init().then {
    $0.text = "티켓 가격 15% 할인"
    $0.font = .font(.pretendardMedium, ofSize: 14)
    $0.textColor = .gray900
  }
  private let usageBasicLabel: UILabel = .init().then {
    $0.text = "이용방법"
    $0.font = .font(.pretendardBold, ofSize: 18)
    $0.textColor = .gray900
  }
  private lazy var secondSeparateLine = makeLine()
  private let usageLabel: UILabel = .init().then {
    $0.text = "학생증/청소년증 제시"
    $0.font = .font(.pretendardMedium, ofSize: 14)
    $0.textColor = .gray900
  }
  private let categoryView = CategoryView()
  override func viewDidLoad() {
    super.viewDidLoad()
    setLayout()
    addNavigationViewToSubview()
  }
}

extension ContentDetailViewController {
  private func setLayout() {
    contentView.addSubviews(scrollView)
    scrollView.addSubviews(categoryView,
                           contentTitle,
                           categoryCardImageView,
                           locationBasicLabel,
                           locationLabel,
                           durationBasicLabel,
                           durationLabel,
                           contentImageView,
                           urlRoundButton,
                           contentInfoLabel,
                           benefitBasicLabel,
                           firstSepareteLine,
                           benefitLabel,
                           usageBasicLabel,
                           secondSeparateLine,
                           usageLabel)
    scrollView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    categoryView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(23)
      $0.top.equalToSuperview().inset(8)
      $0.width.equalTo(49)
      $0.height.equalTo(33)
    }
    contentTitle.snp.makeConstraints {
      $0.top.equalTo(categoryView.snp.bottom).offset(8)
      $0.leading.equalTo(categoryView)
    }
    categoryCardImageView.snp.makeConstraints {
      $0.centerY.equalTo(contentTitle)
      $0.leading.equalTo(contentTitle.snp.trailing).offset(9)
      $0.width.equalTo(18)
      $0.height.equalTo(25)
    }
    locationBasicLabel.snp.makeConstraints {
      $0.top.equalTo(contentTitle.snp.bottom).offset(16)
      $0.leading.equalTo(contentTitle)
    }
    locationLabel.snp.makeConstraints {
      $0.top.equalTo(locationBasicLabel)
      $0.leading.equalTo(locationBasicLabel.snp.trailing).offset(24)
    }
    durationBasicLabel.snp.makeConstraints {
      $0.top.equalTo(locationBasicLabel.snp.bottom).offset(8)
      $0.leading.equalTo(locationBasicLabel)
    }
    durationLabel.snp.makeConstraints {
        $0.top.equalTo(durationBasicLabel)
        $0.leading.equalTo(durationBasicLabel.snp.trailing).offset(24)
    }
    contentImageView.snp.makeConstraints {
      $0.top.equalTo(durationBasicLabel.snp.bottom).offset(32)
      $0.centerX.equalToSuperview()
//      $0.leading.trailing.equalTo(contentView)
      $0.width.equalTo(375)
      $0.height.equalTo(240)
    }
    showUrlRoundButton()
    setInfoLabelLayoutWithButton()
    benefitBasicLabel.snp.makeConstraints {
      $0.top.equalTo(contentInfoLabel.snp.bottom).offset(40)
      $0.leading.equalTo(contentInfoLabel)
    }
    firstSepareteLine.snp.makeConstraints {
      $0.top.equalTo(benefitBasicLabel.snp.bottom).offset(16)
      $0.leading.trailing.equalTo(contentView).inset(24)
      $0.height.equalTo(1)
    }
    benefitLabel.snp.makeConstraints {
      $0.top.equalTo(firstSepareteLine.snp.bottom).offset(16)
      $0.leading.equalTo(benefitBasicLabel)
    }
    usageBasicLabel.snp.makeConstraints {
      $0.top.equalTo(benefitLabel.snp.bottom).offset(40)
      $0.leading.equalTo(benefitBasicLabel)
    }
    secondSeparateLine.snp.makeConstraints {
      $0.top.equalTo(usageBasicLabel.snp.bottom).offset(16)
      $0.leading.trailing.equalTo(contentView).inset(24)
      $0.height.equalTo(1)
    }
    usageLabel.snp.makeConstraints {
      $0.top.equalTo(secondSeparateLine.snp.bottom).offset(16)
      $0.leading.equalTo(usageBasicLabel)
      $0.bottom.equalToSuperview().inset(30)
    }
  }
  private func showUrlRoundButton() {
    urlRoundButton.snp.makeConstraints {
      $0.top.equalTo(contentImageView.snp.bottom).offset(24)
      $0.leading.equalToSuperview().inset(24)
      $0.width.equalTo(136)
      $0.height.equalTo(36)
    }
    urlRoundButton.addSubviews(urlButtonLabel, urlButtonImage)
    urlButtonLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(12)
    }
    urlButtonImage.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(12)
      $0.width.height.equalTo(20)
    }
  }
  private func setInfoLabelLayoutWithButton() {
    contentInfoLabel.snp.makeConstraints {
      $0.top.equalTo(urlRoundButton.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview().inset(24)
    }
  }
  private func setInfoLabelLayoutWithoutButton() {
    contentInfoLabel.snp.makeConstraints {
      $0.top.equalTo(contentImageView.snp.bottom).offset(24)
      $0.leading.trailing.equalToSuperview().inset(24)
    }
  }
  func bindContentDetailData(model: HomeContentModel) {
//    dateLabel.text = setDateLabel(model: model)
    contentTitle.text = model.contentTitle
  }
  @objc
  private func touchUpUrlRoundButton() {
    print("touch up Url Button")
  }
}

extension ContentDetailViewController {
  private func makeLine() -> UIView {
    let line: UIView = .init().then {
      $0.backgroundColor = .gray500
    }
    return line
  }
}
