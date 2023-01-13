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

enum IDType: String {
  case schoolID = "학교"
  case teenID = "생년월일"
  
  var title: String {
    switch self {
    case .schoolID:
      return "학생증"
    case .teenID:
      return "청소년증"
    }
  }
  
  var placeholder: String {
    switch self {
    case .teenID:
      return "YYMMDD"
    case .schoolID:
      return "OO학교"
    }
  }
}

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
  private var ocrTexts: [String]
  private var type: IDType
  
  init(ocrTexts: [String]) {
    self.ocrTexts = ocrTexts
    self.type = ocrTexts.contains("청소년증") == true ? IDType.teenID : IDType.schoolID
    super.init()
  }
  
  private func addSubview() {
    let idDetailView = IDInfoEditableView(frame: .zero, actions: actions, ocrTexts: ocrTexts, type: type)
    contentView.addSubview(idDetailView)
    idDetailView.snp.makeConstraints {
      $0.left.right.top.bottom.equalToSuperview()
    }

  }

}
