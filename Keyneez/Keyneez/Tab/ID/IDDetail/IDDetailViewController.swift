//
//  IDDetailViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/6/23.
//

import UIKit

class IDDetailViewController: BottomSheetViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubview()
  }
  
  private lazy var actions: IDDetailActionables = IDDetailActions(viewController: self)
    
  private func addSubview() {
    let idDetailView = IDdetailView(frame: .zero, actions: actions)
    contentView.addSubview(idDetailView)
    idDetailView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }
  }
  
}
