//
//  IDIssuedViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/9/23.
//

import UIKit

class IDIssuedViewController: NiblessViewController, NavigationBarProtocol {
  
  // 커스텀 네비게이션 뷰 생성
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backbutton), .flexibleBox]).build()
  
  private var backbutton: UIButton = .init(primaryAction: nil).then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback"), for: .normal)
  }
  // 컨텐츠 뷰 생성
  var action = IDContentActions()
  lazy var contentView: UIView = IDIssuedView(frame: .zero, action: action)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addNavigationViewToSubview()
  }
    
}
