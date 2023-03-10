//
//  PropensityTagCollectionView.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/08.
//

import UIKit
import SnapKit
import Then

private struct Constant {
  static let firstBtnTop: CGFloat = 86
  static let btnPadding: CGFloat = 32
  static let btnLeading: CGFloat = 24
  static let btnHeight: CGFloat = 61
  static let btnMargin: CGFloat = 16
}

final class PropensityTagViewController: NiblessViewController, NavigationBarProtocol {
  
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .flexibleBox]).build()
   var contentView = UIView()
   
   private lazy var backButton: UIButton = .init(primaryAction: touchUpBackButton).then {
     $0.setBackgroundImage(UIImage(named: "ic_arrowback_search"), for: .normal)
   }
   private lazy var touchUpBackButton: UIAction = .init(handler: { _ in
     self.navigationController?.popViewController(animated: true)
   })
   
  // MARK: - UI Components
  
  private let titleLabel = UILabel().then {
    $0.text = "젤리에게 나를 소개해 주세요!\n자유시간에 나는 .."
    $0.font = .font(.pretendardBold, ofSize: 24)
    $0.numberOfLines = 0
  }
  
  private let activeButton = UIButton().then {
    $0.tag = 0
    $0.setBackgroundImage(UIImage(named: propensityTagUnclickData[$0.tag].text), for: .normal)
    $0.isUserInteractionEnabled = true
    $0.addTarget(self, action: #selector(selectOptionBtnAction), for: .touchUpInside)
  }
  private let curiousButton = UIButton().then {
    $0.tag = 1
    $0.setBackgroundImage(UIImage(named: propensityTagUnclickData[$0.tag].text), for: .normal)
    $0.isUserInteractionEnabled = true
    $0.addTarget(self, action: #selector(selectOptionBtnAction), for: .touchUpInside)
  }
  private let comportableButton = UIButton().then {
    $0.tag = 2
    $0.setBackgroundImage(UIImage(named: propensityTagUnclickData[$0.tag].text), for: .normal)
    $0.isUserInteractionEnabled = true
    $0.addTarget(self, action: #selector(selectOptionBtnAction), for: .touchUpInside)
  }
  
   lazy var pushToHashVCButton = UIButton().then {
    $0.keyneezButtonStyle(style: .blackUnact, title: "다음으로")
     $0.addTarget(self, action: #selector(touchUpNextVC), for: .touchUpInside)
   }
   
   @objc
   private func touchUpNextVC() {
     let hashTagVC = HashTagViewController()
     for button in btnArray {
       if button.isSelected == true {
         hashTagVC.dataBind(propensity: button.tag)
         pushToNextVC(VC: hashTagVC)
       }
     }
   }
  
  private var btnArray = [UIButton]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addNavigationViewToSubview()
    setConfig()
    setLayout()
  }
  
  @objc
  private func selectOptionBtnAction(_ sender: UIButton) {
    
    for button in btnArray {
      if button == sender {
        button.isSelected = true
        button.setBackgroundImage(UIImage(named: propensityTagClickData[button.tag].text), for: .normal)
        button.titleLabel?.font = .font(.pretendardMedium, ofSize: 22)
        pushToHashVCButton.keyneezButtonStyle(style: .blackAct, title: "다음으로")
      } else {
        button.isSelected = false
        button.setBackgroundImage(UIImage(named: propensityTagUnclickData[button.tag].text), for: .normal)

      }
    }
  }
}

extension PropensityTagViewController {
  private func setConfig() {
    view.backgroundColor = .gray050
    [activeButton, curiousButton, comportableButton].forEach {
      btnArray.append($0)
    }
    [titleLabel, activeButton, curiousButton, comportableButton, pushToHashVCButton].forEach {
      contentView.addSubview($0)
    }
    
  }
  private func setLayout() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(SignUpConstant.labelTop)
      $0.leading.equalToSuperview().offset(SignUpConstant.labelLeading)
    }
    activeButton.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Constant.firstBtnTop)
      $0.leading.equalTo(titleLabel)
      $0.height.equalTo(Constant.btnHeight)
    }
    curiousButton.snp.makeConstraints {
      $0.top.equalTo(activeButton.snp.bottom).offset(Constant.btnPadding)
      $0.leading.equalTo(activeButton)
      $0.height.equalTo(Constant.btnHeight)
    }
    comportableButton.snp.makeConstraints {
      $0.top.equalTo(curiousButton.snp.bottom).offset(Constant.btnPadding)
      $0.leading.equalTo(activeButton)
      $0.height.equalTo(Constant.btnHeight)
    }
    pushToHashVCButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(40)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalTo(SignUpConstant.buttonHeight)
    }
    
  }
}
