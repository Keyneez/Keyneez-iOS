//
//  HomeViewController.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/02.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: NiblessViewController, NavigationBarProtocol {
  
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.logo, .flexibleBox, .iconButton(with: searchButton)]).build()
  
  lazy var contentView: UIView = UIView()
  
  // SegmentedControl 담을 뷰
  private lazy var containerView: UIView = .init().then {
    $0.backgroundColor = .clear
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private lazy var searchButton: UIButton = .init(primaryAction: didSearch).then {
    $0.setBackgroundImage(UIImage(named: "ic_search"), for: .normal)
  }
  
  private var didSearch: UIAction = .init(handler: { _ in print("hi")})
 
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    addNavigationViewToSubview()
  }
  
  func configure() {
    contentView.addSubviews(containerView)
    
    
    containerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(48)
    }

  }

}
