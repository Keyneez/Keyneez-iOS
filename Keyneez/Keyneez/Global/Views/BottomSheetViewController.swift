//
//  BottomSheetViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/7/23.
//

import UIKit
import Then

class BottomSheetViewController: NiblessViewController {
  
  var contentView: UIView = .init().then {
    $0.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    setupContentView()
    setPanGesture()
  }
  
  private func setupContentView() {
    view.addSubview(contentView)
    contentView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  override func viewDidLayoutSubviews() {
    contentView.setRound([.topLeft, .topRight], radius: 22)
  }
  
}

// MARK: - PanGesture

extension BottomSheetViewController {
  
  private func setPanGesture() {
    let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
    viewPan.delaysTouchesBegan = false
    viewPan.delaysTouchesEnded = false
    view.addGestureRecognizer(viewPan)
  }
  
  @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
    let velocity = panGestureRecognizer.velocity(in: view)
    if panGestureRecognizer.state == .ended && velocity.y > 1500 {
      self.dismiss(animated: true)
      return
    }
  }
}
