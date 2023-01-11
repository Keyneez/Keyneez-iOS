//
//  IDViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/4/23.
//

enum UserID {
  case yes
  case no
}

var userid: UserID = .no

import UIKit

final class IDViewController: NiblessViewController, NavigationBarProtocol {
  
  // 커스텀 네비게이션 뷰 생성
  var navigationView: UIView = NavigationViewBuilder(barViews: [.logo(color: .white), .flexibleBox]).build()
  
  lazy var actions: IDContentActions = IDContentActions(viewcontroller: self)
  
  // 컨텐츠 뷰 생성
  lazy var contentView: UIView = userid == .yes ? IDCardContentView(frame: .zero, actions: actions) : IDNotAvailableView(frame: .zero, action: actions)
  
  override init() {
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addNavigationViewToSubview()
    setBackgroundColorToBlack()
    
  }
}
extension IDViewController {
  
  private func setBackgroundColorToBlack() {
    view.backgroundColor = .gray800
  }
  
}
