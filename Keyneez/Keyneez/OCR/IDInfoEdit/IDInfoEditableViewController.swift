//
//  IDInfoEditableViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/9/23.
//

/**
 OCR로 불러왔을때
 1. 이름
 2. 고등학교
 3. 생년월일
 
 네트워크 통신 가능여부
 1. 이름
 2. 고등학교
 3. 사진
 
 1. 이름
 2. 생년월일
 3. 사진
 
 하나라도 없으면 통신 X -> 오류 방출
 
 */

import UIKit

final class IDInfoEditableViewController: BottomSheetViewController {
    
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubview()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
  }
  
  private lazy var actions: IDInfoEditableActionables = IDInfoEditableActions(viewController: self)
  
  private func addSubview() {
    let idDetailView = IDInfoEditableView(frame: .zero, actions: actions)
    contentView.addSubview(idDetailView)
    idDetailView.snp.makeConstraints {
      $0.left.right.top.bottom.equalToSuperview()
    }

  }

}
