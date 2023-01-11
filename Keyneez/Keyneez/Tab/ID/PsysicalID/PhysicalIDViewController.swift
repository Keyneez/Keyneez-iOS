//
//  physicalIDViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/10/23.
//

import UIKit

class PhysicalIDViewController: NiblessViewController, NavigationBarProtocol {
  
  // 커스텀 네비게이션 뷰 생성
  lazy var navigationView: UIView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private lazy var backButton: UIButton = .init(primaryAction: action.dismiss()).then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback"), for: .normal)
  }
  private lazy var titleLabel: UILabel = .init().then {
    $0.font = .font(.pretendardBold, ofSize: 20)
    $0.textColor = .gray900
    $0.text = "실물인증"
  }
  
  // 컨텐츠 뷰 생성
  var contentView: UIView = UIView()
  lazy var action: PhysicalIDActionables = PhysicalIDActions(viewcontroller: self)
  
  override init() {
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    [backButton, titleLabel].forEach { self.navigationView.addSubviews($0) }
    
    backButton.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(24)
      $0.centerY.equalToSuperview()
      $0.height.width.equalTo(32)
    }
    titleLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    addNavigationViewToSubview()
  }
    
}
