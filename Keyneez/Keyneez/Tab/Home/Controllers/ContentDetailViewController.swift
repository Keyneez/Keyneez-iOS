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
  private let scrollView: UIScrollView = .init()
  private let contentContainerView: UIView = .init()
  private let contentTitle: UILabel = .init().then {
    $0.font = UIFont.font(.pretendardBold, ofSize: 24)
    $0.textColor = UIColor.gray900
  }
  private let categoryCardImageView: UIImageView = .init().then {
    $0.image = UIImage(named: "card_black_contentDetail")
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
    scrollView.addSubviews(categoryView, contentTitle, categoryCardImageView)
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
  }
  func bindContentDetailData(model: HomeContentModel) {
//    dateLabel.text = setDateLabel(model: model)
    contentTitle.text = model.contentTitle
  }
}
