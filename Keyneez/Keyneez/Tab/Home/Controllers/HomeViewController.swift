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
  
  private lazy var segmentControl: UISegmentedControl = .init().then {
    $0.selectedSegmentTintColor = .clear
    // 배경 색 제거
    $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
    // Segment 구분 라인 제거
    $0.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    $0.insertSegment(withTitle: "추천", at: 0, animated: true)
    $0.insertSegment(withTitle: "인기", at: 1, animated: true)
    $0.insertSegment(withTitle: "최신", at: 2, animated: true)
    $0.selectedSegmentIndex = 0
    
    // 선택 되어 있지 않을때 폰트 및 폰트컬러
    $0.setTitleTextAttributes([
      NSAttributedString.Key.foregroundColor: UIColor.gray400,
      NSAttributedString.Key.font: UIFont.font(.pretendardMedium, ofSize: 24)
    ], for: .normal)
    
    // 선택 되었을때 폰트 및 폰트컬러
    $0.setTitleTextAttributes([
      NSAttributedString.Key.foregroundColor: UIColor.gray900,
      NSAttributedString.Key.font: UIFont.font(.pretendardBold, ofSize: 24)
    ], for: .selected)
    
//    $0.addTarget(self, action: #selector(changeUnderLinePosition), for: .valueChanged)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private lazy var underLineView: UIView = .init().then {
    $0.backgroundColor = .gray900
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    addNavigationViewToSubview()
  }
  
  func configure() {
    contentView.addSubviews(containerView)
    containerView.addSubviews(segmentControl)
    
    containerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(48)
    }
    segmentControl.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(2)
    }
  }
}

