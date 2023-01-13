//
//  ContentDetailViewController.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/09.
//

import UIKit
import Then
import SnapKit
import SafariServices

final class ContentDetailViewController: NiblessViewController, NavigationBarProtocol {
  
  var isLiked: Bool = false
  private var contentLink: String = ""
  
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .flexibleBox, .iconButton(with: shareButton), .sizedBox(width: 16), .iconButton(with: likeButton)]).build()
  private lazy var backButton = makeIconButton(imageName: "ic_arrowback_search", action: touchUpBackButton)
  private lazy var shareButton = makeIconButton(imageName: "ic_share3", action: touchUpShareButton)
  private lazy var likeButton = makeIconButton(imageName: "Property 1=line", action: touchUpLikeButton)
  private lazy var touchUpBackButton: UIAction = .init(handler: { _ in
    self.navigationController?.popViewController(animated: true)
  })
  private lazy var touchUpShareButton: UIAction = .init(handler: { _ in
    print("touch up ShareButton")
  })
  private lazy var touchUpLikeButton: UIAction = .init(handler: { _ in
//    self.likeButton.isSelected = !self.likeButton.isSelected
    print("touch up like button")
    self.setLikeButton(isLiked: !self.isLiked)
  })
  var contentView: UIView = .init()
  private let scrollView: UIScrollView = .init().then {
    $0.showsVerticalScrollIndicator = false
  }
  private let contentContainerView: UIView = .init()
  private let contentTitle: UILabel = .init().then {
    $0.text = "예시 타이틀"
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
  private lazy var locationLabel = makeLabel(text: "서울 킨텍스")
  private let durationBasicLabel: UILabel = .init().then {
    $0.text = "기간"
    $0.font = .font(.pretendardBold, ofSize: 14)
    $0.textColor = .gray900
  }
  private lazy var durationLabel: UILabel = makeLabel(text: "22.11.24-22.12.31")
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
  private lazy var contentInfoLabel = makeLabel(text: "어찌구저찌구 활동 설명입니다.")
  private lazy var benefitBasicLabel = makeBasicLabel(text: "청소년 혜택")
  private lazy var firstSepareteLine = makeLine()
  private lazy var benefitLabel = makeLabel(text: "티켓 가격 15% 할인")
  private lazy var usageBasicLabel = makeBasicLabel(text: "이용방법")
  private lazy var secondSeparateLine = makeLine()
  private lazy var usageLabel = makeLabel(text: "학생증/청소년증 제시")
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
      $0.leading.trailing.equalTo(contentView).inset(24)
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
      $0.leading.trailing.equalTo(contentView).inset(24)
      $0.bottom.equalToSuperview().inset(100)
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
      $0.leading.trailing.equalTo(contentView).inset(24)
    }
  }
  private func setInfoLabelLayoutWithoutButton() {
    contentInfoLabel.snp.makeConstraints {
      $0.top.equalTo(contentImageView.snp.bottom).offset(24)
      $0.leading.trailing.equalTo(contentView).inset(24)
    }
  }
  @objc
  private func touchUpUrlRoundButton() {
    goToSite(url: contentLink)
  }
  func bindContentDetailData(model: ContentDetailResponseDto) {
    contentTitle.text = deleteNewLine(fullString: model.contentTitle)
    locationLabel.text = deleteNewLine(fullString: model.place)
    durationLabel.text = setDateLabel(model: model)
    contentInfoLabel.text = model.introduction
    benefitLabel.text = model.benefit
    usageLabel.text = model.usage
    benefitLabel.setLineSpacing(spacing: 8)
    usageLabel.setLineSpacing(spacing: 8)
    setLikeButton(isLiked: model.liked)
    guard let url = model.contentImg else { return }
    contentImageView.setImage(url: url)
    categoryView.setCategory(with: model.category[0])
    contentLink = model.contentLink
  }
  private func goToSite(url: String) {
    let safariView: SFSafariViewController = SFSafariViewController(url: URL(string: url)!)
    self.present(safariView, animated: true, completion: nil)
  }
}

extension ContentDetailViewController {
  private func makeLine() -> UIView {
    let line: UIView = .init().then {
      $0.backgroundColor = .gray500
    }
    return line
  }
  private func makeBasicLabel(text: String) -> UILabel {
    let label: UILabel = .init().then {
      $0.text = text
      $0.font = .font(.pretendardBold, ofSize: 18)
      $0.textColor = .gray900
    }
    return label
  }
  private func makeLabel(text: String) -> UILabel {
    let label: UILabel = .init().then {
      $0.text = text
      $0.font = .font(.pretendardMedium, ofSize: 14)
      $0.textColor = .gray900
      $0.lineBreakStrategy = .hangulWordPriority
      $0.numberOfLines = 0
    }
    return label
  }
  private func makeIconButton(imageName: String, action: UIAction) -> UIButton {
    let button: UIButton = .init(primaryAction: action).then {
      $0.setBackgroundImage(UIImage(named: imageName), for: .normal)
    }
    return button
  }
  private func deleteNewLine(fullString: String) -> String {
    guard let text = fullString as? String else {return ""}
        return text.replacingOccurrences(of: "\n", with: " ")
  }
  private func getDate(fullDate: String) -> String {
    let monthIndex = fullDate.index(fullDate.endIndex, offsetBy: -4)
    let dayIndex = fullDate.index(fullDate.endIndex, offsetBy: -2)
    let month = String(fullDate[monthIndex..<dayIndex])
    let day = (fullDate[dayIndex...])
    return month + "." + day
  }
  private func setDateLabel(model: ContentDetailResponseDto) -> String {
    if model.startAt == nil || model.endAt == nil { return "2023 ~" }
    if model.startAt!.isEmpty || model.endAt!.isEmpty { return "2023 ~" }
    return getDate(fullDate: model.startAt!) + " ~ " + getDate(fullDate: model.endAt!)
  }
  private func setLikeButton(isLiked: Bool) {
    if isLiked {
      likeButton.setImage(UIImage(named: "Property 1=fill"), for: .normal)
      self.isLiked = true
    } else {
      likeButton.setImage(UIImage(named: "Property 1=line"), for: .normal)
      self.isLiked = false
    }
  }
}
