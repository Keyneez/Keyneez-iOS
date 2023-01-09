//
//  SignUpViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/08.
//

import UIKit
import Then

final class SignUpViewController: NiblessViewController, NavigationBarProtocol {
  
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .flexibleBox]).build()
  
  private var backButton : UIButton = .init(primaryAction: nil).then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback"), for: .normal)
  }
  
  var actions = SignUpActions()
  // 컨텐츠 뷰 생성
  lazy var contentView: UIView = SimplePwdViewController(frame: .zero, actions: actions)
  
    override func viewDidLoad() {
        super.viewDidLoad()
      addNavigationViewToSubview()
      view.backgroundColor = .gray050
      print(propensityTagClickData[0].text)

    }
}
