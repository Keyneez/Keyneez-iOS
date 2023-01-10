//
//  PropensityTagViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/11.
//

import UIKit

class PropensityTagViewController: NiblessViewController, NavigationBarProtocol {
  
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .flexibleBox]).build()
  
  private var backButton : UIButton = .init(primaryAction: nil).then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback"), for: .normal)
  }
  
  var actions = SignUpActions()

  lazy var contentView: UIView = PropensityTagView(frame: .zero, actions: actions)
  
    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .gray050
      addNavigationViewToSubview()
      
    }
}
