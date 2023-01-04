//
//  IDViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/4/23.
//

import UIKit

final class IDViewController: NiblessViewController, NavigationBarProtocol {
  
  // 커스텀 네비게이션 뷰 생성
  var navigationView: UIView = NavigationViewBuilder(barViews: [.logo(color: .white), .flexibleBox]).build()
  
  // 컨텐츠 뷰 생성
  var contentView: UIView = IDContentView()
  
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
