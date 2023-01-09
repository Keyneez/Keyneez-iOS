//
//  ContentDetailViewController.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/09.
//

import UIKit

final class ContentDetailViewController: NiblessViewController, NavigationBarProtocol {
  
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .flexibleBox, .iconButton(with: shareButton), .sizedBox(width: 16), .iconButton(with: likeButton)]).build()
  private lazy var backButton: UIButton = .init(primaryAction: touchUpBackButton).then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback_search"), for: .normal)
  }
  private lazy var shareButton: UIButton = .init(primaryAction: touchUpShareButton).then {
    $0.setBackgroundImage(UIImage(named: "ic_share3"), for: .normal)
  }
  private lazy var likeButton: UIButton = .init(primaryAction: touchUpLikeButton).then {
    $0.setBackgroundImage(UIImage(named: "Property 1=line"), for: .normal)
  }
  private lazy var touchUpBackButton: UIAction = .init(handler: { _ in
    self.navigationController?.popViewController(animated: true)
  })
  private lazy var touchUpShareButton: UIAction = .init(handler: { _ in
    print("touch up ShareButton")
  })
  private lazy var touchUpLikeButton: UIAction = .init(handler: { _ in
    print("touch up LikeButton")
  })
  var contentView: UIView = .init()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addNavigationViewToSubview()
  }
    
}
