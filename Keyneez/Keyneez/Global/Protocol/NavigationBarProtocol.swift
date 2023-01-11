//
//  NavigationBarProtocol.swift
//  Keyneez
//
//  Created by Jung peter on 1/3/23.
//

import UIKit
import SnapKit

private struct Constant {
  static let navigationViewHeight: CGFloat = 56
}

protocol NavigationBarProtocol where Self: NiblessViewController {
  var navigationView: UIView { get set }
  var contentView: UIView {get set}
}

extension NavigationBarProtocol {
  
  func addNavigationViewToSubview() {
    view.addSubview(navigationView)
    view.addSubview(contentView)
    let guide = view.safeAreaLayoutGuide
    navigationView.snp.makeConstraints { make in
      make.left.right.top.equalTo(guide)
      make.height.equalTo(Constant.navigationViewHeight)
      make.bottom.equalTo(contentView.snp.top)
    }
    contentView.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
    }
  }
  
}
