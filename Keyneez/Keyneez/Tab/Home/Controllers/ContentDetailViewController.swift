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
  let scrollView: UIScrollView = .init().then {
    $0.backgroundColor = .gray500
  }
//  private let categoryView = UIView().then {
//    $0.backgroundColor = .clear
//    $0.layer.cornerRadius = 16
//    $0.layer.borderWidth = 1.5
//    $0.layer.borderColor = UIColor.mint400.cgColor
//  }
//  private let category = UILabel().then {
//    $0.textColor = UIColor.mint400
//    $0.font = UIFont.font(.pretendardBold, ofSize: 14)
//  }
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
    scrollView.addSubviews(categoryView)
    scrollView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    categoryView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(23)
      $0.top.equalToSuperview().inset(8)
    }
  }
//  func bindContentDetailData(model: HomeSearchModel) {
//    dateLabel.text = setDateLabel(model: model)
//    titleLabel.text = model.contentTitle
//  }
}
