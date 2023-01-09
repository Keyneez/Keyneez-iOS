//
//  ContentDetailViewController.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/09.
//

import UIKit

final class ContentDetailViewController: NiblessViewController, NavigationBarProtocol {
  
  // 커스텀 네비게이션 뷰 생성
  var navigationView: UIView
  
  // 컨텐츠 뷰 생성
  var contentView: UIView
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addNavigationViewToSubview()
  }
    
}
