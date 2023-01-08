//
//  SearchViewController.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/09.
//

import UIKit

final class SearchViewController: NiblessViewController, NavigationBarProtocol {
//  var navigationView: UIView = NavigationViewBuilder(barViews: [.button(with: "ic_arrowback"), .textfield(configure: (placeholder: "검색", completion: { _ in print("hi") })]).build()
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.logo(color: .black), .flexibleBox, .iconButton(with: searchButton)]).build()
  private lazy var searchButton: UIButton = .init(primaryAction: didSearch).then {
    $0.setBackgroundImage(UIImage(named: "ic_search"), for: .normal)
  }
  private var didSearch: UIAction = .init(handler: { _ in print("hi") })
  
  // 컨텐츠 뷰 생성
  var contentView: UIView = UIView().then {
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    addNavigationViewToSubview()
//  }
    
}
