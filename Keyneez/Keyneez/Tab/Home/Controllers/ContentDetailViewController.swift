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
  let testUIView1: UIView = .init().then {
    $0.backgroundColor = .mint200
  }
  let testUIView2: UIView = .init().then {
    $0.backgroundColor = .mint200
  }
  let testUIView3: UIView = .init().then {
    $0.backgroundColor = .mint200
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setLayout()
    addNavigationViewToSubview()
  }
}

extension ContentDetailViewController {
  private func setLayout() {
    contentView.addSubviews(scrollView)
    scrollView.addSubviews(testUIView1, testUIView2, testUIView3)
    scrollView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    testUIView1.snp.makeConstraints {
      $0.top.leading.equalToSuperview().inset(30)
      $0.width.height.equalTo(300)
    }
    testUIView2.snp.makeConstraints {
      $0.top.equalTo(testUIView1.snp.bottom).offset(30)
      $0.leading.equalToSuperview().inset(30)
      $0.width.height.equalTo(300)
    }
    testUIView3.snp.makeConstraints {
      $0.top.equalTo(testUIView2.snp.bottom).offset(30)
      $0.leading.equalToSuperview().inset(30)
      $0.width.height.equalTo(300)
      $0.bottom.equalToSuperview().inset(30)
    }
  }
}
