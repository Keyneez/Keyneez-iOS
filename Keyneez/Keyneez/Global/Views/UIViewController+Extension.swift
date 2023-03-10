//
//  UIViewController+Extension.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/09.
//

import UIKit

extension UIViewController {
  func pushToContentDetailView(model: ContentDetailResponseDto) {
    let contentDetailViewController = ContentDetailViewController()
    contentDetailViewController.bindContentDetailData(model: model)
    self.navigationController?.pushViewController(contentDetailViewController, animated: true)
  }
  func pushToNextVC(VC: UIViewController) {
    let nextVC = VC
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
}
