//
//  SignUpViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/08.
//

import UIKit
import Then

class SignUpViewController: NiblessViewController, NavigationBarProtocol {
  
  var navigationView: UIView = NavigationViewBuilder(barViews: [ .flexibleBox]).build()
  
  private lazy var backButton = UIButton().then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback"), for: .normal)
  }
  
  var actions = SignUpActions()
  // 컨텐츠 뷰 생성
  lazy var contentView: UIView = HashTagCollectionViewController(frame: .zero, actions: actions)
  
    override func viewDidLoad() {
        super.viewDidLoad()
      addNavigationViewToSubview()
      view.backgroundColor = .gray050
      print(propensityTagClickData[0].text)

    }
}
