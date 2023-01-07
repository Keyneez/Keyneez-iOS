//
//  SeparatedButton.swift
//  Keyneez
//
//  Created by Jung peter on 1/6/23.
//

import UIKit

private struct Constant {
  static let separatedViewInset: CGFloat = 8.5
  static let buttonTitleFont: CGFloat = 16
  static let numberOfButtons = 2
  static let viewRadius: CGFloat = 9
  static let errorMessage = "titles, actions should be 2"
  static let sepratedViewWidth: CGFloat = 1
}

final class SeperatedButton: NiblessView {
  
  private var buttons: [UIButton]
  private var stackview: UIStackView = .init()
  private var separatedView: UIView = .init().then {
    $0.backgroundColor = .gray300
  }
  
  init(frame: CGRect, title: [String], actions: [UIAction]) {
    
    guard title.count == Constant.numberOfButtons && actions.count == Constant.numberOfButtons else { fatalError(Constant.errorMessage)}
    buttons = zip(title, actions).map { configureButton(with: $0) }
    
    super.init(frame: frame)
    composeStackViewWithSubViews()
    setConstraint()
    setbackgroundColor()
    
    func configureButton(with info: (String, UIAction)) -> UIButton {
      let button = UIButton(frame: .zero, primaryAction: info.1)
      button.setTitleColor(.gray800, for: .normal)
      button.titleLabel?.font = .font(.pretendardSemiBold, ofSize: Constant.buttonTitleFont)
      button.setTitle(info.0, for: .normal)
      return button
    }
    
  }
  
  override func layoutSubviews() {
    setRound([.allCorners], radius: Constant.viewRadius)
  }
  
  private func setbackgroundColor() {
    backgroundColor = .white
  }
  
  private func setConstraint() {
    
    separatedView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(Constant.separatedViewInset)
      $0.width.equalTo(Constant.sepratedViewWidth)
    }
    
    buttons.forEach {
      self.setButtonConstaint(button: $0)
    }
    
  }
  
  private func setButtonConstaint(button: UIButton) {
    button.snp.makeConstraints {
      $0.height.equalToSuperview()
      $0.width.equalToSuperview().dividedBy(Constant.numberOfButtons).offset(-(Constant.sepratedViewWidth / 2))
    }
  }
  
  private func composeStackViewWithSubViews() {
    guard let leftbutton = buttons.first, let rightbutton = buttons.last else { fatalError(Constant.errorMessage)}
    stackview = UIStackView(arrangedSubviews: [leftbutton, separatedView, rightbutton])
    stackview.alignment = .center
    stackview.distribution = .fill
    addSubview(stackview)
  
    stackview.snp.makeConstraints {
      $0.left.right.top.bottom.equalToSuperview()
    }
  }
}
