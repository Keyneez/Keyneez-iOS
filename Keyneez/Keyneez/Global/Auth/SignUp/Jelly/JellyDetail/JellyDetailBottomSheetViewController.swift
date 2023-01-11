//
//  JellyDetailBottomSheetViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/10.
//

import UIKit

class JellyDetailBottomSheetViewController: BottomSheetViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      addSubview()
    }
  
  override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
  
  private func addSubview() {
    let jellyDetailView = JellyDetailView()
    contentView.addSubview(jellyDetailView)
    jellyDetailView.snp.makeConstraints {
      $0.top.leading.bottom.trailing.equalToSuperview()
    }
  }

}
