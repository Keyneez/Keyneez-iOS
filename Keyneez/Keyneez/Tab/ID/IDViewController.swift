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
  var actions = IDContentActions()
  
  // 컨텐츠 뷰 생성
  lazy var contentView: UIView = IDCardContentView(frame: .zero, actions: actions)
  
  private lazy var customNavigationDelegate = CustomNavigationManager()
  
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
  
  private func makeAction() -> UIAction {
    return UIAction(handler: { [unowned self] _ in
      let idDetailVC = IDDetailViewController()
      self.customNavigationDelegate.direction = .bottom
      self.customNavigationDelegate.height = 348
      idDetailVC.transitioningDelegate = self.customNavigationDelegate
      idDetailVC.modalPresentationStyle = .custom
      self.present(idDetailVC, animated: true, completion: nil)
    })
  }
}

