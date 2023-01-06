//
//  IDDetailViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/6/23.
//

import UIKit

class IDDetailViewController: NiblessViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubview()
  }
  
  private func addSubview() {
    let actions = IDDetailActions()
    let idDetailView = IDdetailView(frame: .zero, actions: actions)
    view.addSubview(idDetailView)
    idDetailView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }
  }
  
}
