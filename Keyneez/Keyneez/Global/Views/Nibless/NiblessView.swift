//
//  NiblessView.swift
//  Keyneez
//
//  Created by Jung peter on 1/3/23.
//

import UIKit

class NiblessView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  @available(*, unavailable,
              message: "We do not support Storyboard"
  )
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("We do not support Storyboard")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.endEditing(true)
      }
  
}
