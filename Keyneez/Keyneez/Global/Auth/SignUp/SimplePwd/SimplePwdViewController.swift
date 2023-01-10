//
//  simplePwdViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/10.
//

import UIKit
import SnapKit
import Toast
import Then
private struct Constant {
  static let titleTop: CGFloat = 12
  static let imageTop: CGFloat = 31
  static let imageLeading: CGFloat = 88
  static let imageHeight: CGFloat = 20
  static let stackViewTop: CGFloat = 43
  static let stackViewWidth: CGFloat = 146
  static let stackViewHeight: CGFloat = 24
}
class SimplePwdViewController: NiblessView {
  
  private let titleLabel: UILabel = .init().then {
    $0.text = "간편 비밀번호를\n설정해주세요"
    $0.font = .font(.pretendardBold, ofSize: 24)
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  private let progressImageView: UIImageView = .init().then {
    $0.image = pwdProgressImageArray().first
    $0.contentMode = .scaleAspectFit
  }
  private let faceIDStackVIew: UIStackView = .init().then {
    $0.axis = .horizontal
    $0.isUserInteractionEnabled = true
    $0.distribution = .equalSpacing
    $0.spacing = 8
  }
  
  private let checkImageView: UIImageView = .init().then {
    $0.image = pwdCheckImageArray().first
    $0.frame = CGRect(x:0, y: 0, width: 24, height: 24)
  }
  private let checkLabel: UILabel = .init().then {
    $0.text = "Face ID 사용하기"
    $0.font = .font(.pretendardMedium, ofSize: 16)
    $0.textColor = .gray900
  }

  private var actions: SignUpActions

  init(frame: CGRect, actions: SignUpActions) {
    self.actions = actions
    super.init(frame: frame)
    setToast()
    setConfig()
    setLayout()
  }
}

extension SimplePwdViewController {
  private func setToast() {
    self.makeToast("마지막 단계!", duration: 0.5, position: .center)
  }
  private func setConfig() {
    self.backgroundColor = .gray050
    [titleLabel, progressImageView, faceIDStackVIew].forEach {
      self.addSubview($0)
    }
    [checkImageView, checkLabel].forEach {
      faceIDStackVIew.addArrangedSubview($0)
    }
  }
  private func setLayout() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Constant.titleTop)
      $0.centerX.equalToSuperview()
    }
    progressImageView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Constant.imageTop)
      $0.leading.trailing.equalToSuperview().inset(Constant.imageLeading)
      $0.height.equalTo(Constant.imageHeight)
    }
    faceIDStackVIew.snp.makeConstraints {
      $0.top.equalTo(progressImageView.snp.bottom).offset(Constant.stackViewTop)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(Constant.stackViewWidth)
      $0.height.equalTo(Constant.stackViewHeight)
    }
  }
}

private func pwdProgressImageArray() -> [UIImage] {
  var array: [UIImage] = []
  array.append(UIImage(named: "pwd0")!)
  array.append(UIImage(named: "pwd1")!)
  array.append(UIImage(named: "pwd2")!)
  array.append(UIImage(named: "pwd3")!)
  array.append(UIImage(named: "pwd4")!)
  array.append(UIImage(named: "pwd5")!)
  array.append(UIImage(named: "pwd6")!)
  return array
}
private func pwdCheckImageArray() -> [UIImage] {
  var array: [UIImage] = []
  array.append(UIImage(named: "unselect")!)
  array.append(UIImage(named: "select")!)
  return array
}
