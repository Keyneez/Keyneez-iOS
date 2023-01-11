//
//  NiblessViewController.swift
//  Keyneez
//
//  Created by Jung peter on 1/3/23.
//

import UIKit

class NiblessViewController: UIViewController {
  
  public var keyboardHeight:CGFloat = 0
  
  // MARK: - Methods
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable,
              message: "We do not support Storyboard"
  )
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  @available(*, unavailable,
              message: "We do not support Storyboard"
  )
  required init?(coder aDecoder: NSCoder) {
    fatalError("We do not support Storyboard")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationBackSwipeMotion()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  func navigationBackSwipeMotion() {
      self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
}

extension NiblessViewController {
  
  @objc func keyboardWillShow(_ notification: NSNotification) {
    
    if keyboardHeight > 0 { return }
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardRectangle.height
    }
    
  }
  
  @objc func keyboardWillHide(_ notification: NSNotification) {
    self.keyboardHeight = 0
  }
}
