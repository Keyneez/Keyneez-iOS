//
//  SearchViewController.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/09.
//

import UIKit

class SearchViewController: NiblessViewController, NavigationBarProtocol {
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .flexibleBox, .iconButton(with: searchButton)]).build()
  private lazy var searchButton: UIButton = .init(primaryAction: didSearch).then {
    $0.setBackgroundImage(UIImage(named: "ic_search"), for: .normal)
  }
  private lazy var backButton: UIButton = .init(primaryAction: didSearch).then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback_search"), for: .normal)
  }
  private lazy var didSearch: UIAction = .init(handler: { _ in print("hi") })
//  // 커스텀 네비게이션 뷰 생성
//  var navigationView: UIView
//
//  // 컨텐츠 뷰 생성
  var contentView: UIView = UIView()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addNavigationViewToSubview()
  }
    
}
