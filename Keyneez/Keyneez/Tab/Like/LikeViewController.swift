//
//  LikeViewController.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/02.
//

import UIKit

final class LikeViewController: NiblessViewController, NavigationBarProtocol {
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.button(with: myLikeButton), .flexibleBox, .iconButton(with: editButton)]).build()
  private lazy var myLikeButton: UIButton = .init(primaryAction: touchUpMyLikeButton).then {
    $0.setTitle("저장", for: .normal)
    $0.setTitleColor(.gray900, for: .normal)
    $0.titleLabel?.font = .font(.pretendardBold, ofSize: 20)
    $0.frame.size.width = 35
    $0.frame.size.height = 24
  }
  private lazy var touchUpMyLikeButton: UIAction = .init(handler: { _ in
    print("touch up my like button")
  })
  private lazy var editButton: UIButton = .init(primaryAction: touchUpEditButton).then {
    $0.setBackgroundImage(UIImage(named: "ic_edit"), for: .normal)
  }
  private lazy var touchUpEditButton: UIAction = .init { _ in
    print("touchUpEditButton")
  }
  var contentView: UIView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    addNavigationViewToSubview()
  }
}
