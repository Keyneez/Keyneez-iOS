//
//  BenefitInfoViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/7/23.
//

import UIKit

class BenefitInfoViewController: BottomSheetViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubview()
  }
  
  private func addSubview() {
    let benefitInfoView = BenefitInfoView()
    contentView.addSubview(benefitInfoView)
    benefitInfoView.snp.makeConstraints {
      $0.top.left.right.bottom.equalToSuperview()
    }
  }
  
}
