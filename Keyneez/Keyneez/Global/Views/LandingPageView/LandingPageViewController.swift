//
//  LandingPageViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/06.
//

import UIKit
import Then
import SnapKit

// TODO: - Action Event 달기

// MARK: - Constant

private struct Constant {
  static let navigationBarHeight: CGFloat = 56
  static let logoWidth: CGFloat = 130
  static let logoHeight: CGFloat = 48
  static let logoBottomMargin: CGFloat = 40
  static let mainImageWidth: CGFloat = 244
  static let mainImageHeight: CGFloat = 334
  static let bottomMargin: CGFloat = 32
  static let landingBarBottomMargin: CGFloat = 90
  static let buttonWidth: CGFloat = 16
  static let buttonBottomMargin: CGFloat = 12
  static let buttonHeight: CGFloat = 48
  static let pageControlWidth: CGFloat = 200
  static let pageControlHeight: CGFloat = 12
}

class LandingPageViewController: UIViewController {
  
  static var landingImages = ["Landing1", "Landing2", "Landing3", "Landing4"]

  // MARK: - UI Components
  
  let logoImageView = UIImageView().then {
    $0.image = UIImage(named: "logoA")
  }
  
  private let pageControl = UIPageControl().then {
    $0.numberOfPages = landingImages.count
    $0.currentPage = 0
    $0.pageIndicatorTintColor = UIColor.gray200
    $0.currentPageIndicatorTintColor = UIColor.mint500
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let scrollView = UIScrollView().then {
    $0.bounces = false
    $0.alwaysBounceHorizontal = true
    $0.showsVerticalScrollIndicator = false
    $0.showsHorizontalScrollIndicator = false
    $0.isScrollEnabled = true
    $0.isPagingEnabled = true
  }
  
  private lazy var signUpButton = {
    let button = UIButton()
    button.keyneezButtonStyle(style: .whiteAct, title: "회원가입")
    button.layer.isHidden = true
    button.addTarget(self, action: #selector(touchUpSignUpVC), for: .touchUpInside)
    return button
  }()
  
  @objc
  private func touchUpSignUpVC() {
    pushToNextVC(VC: DanalAuthViewController())
  }
  
  private lazy var signInButton = UIButton().then {
    $0.keyneezButtonStyle(style: .blackAct, title: "로그인")
    $0.layer.isHidden = true
    $0.addTarget(self, action: #selector(touchUpLoginVC), for: .touchUpInside)
  }
  
  @objc
  private func touchUpLoginVC() {
    pushToNextVC(VC: PhoneLoginViewController())
  }
  
  // MARK: - Functions
  
  private func setScrollContentView() {
    scrollView.delegate = self
    
    for index in 0..<LandingPageViewController.landingImages.count {
      let imageView = UIImageView()
      let positionX = (self.view.frame.width) * CGFloat(index) + (self.view.frame.width / 2) - (Constant.mainImageWidth / 2)
      imageView.frame = CGRect(x: positionX, y: 0, width: Constant.mainImageWidth, height: Constant.mainImageHeight)
      imageView.image = UIImage(named: LandingPageViewController.landingImages[index])
      scrollView.addSubview(imageView)
      scrollView.contentSize.width = self.view.frame.width * CGFloat(index + 1)
    }
  }
  
  private func selectedPage(currentPage: Int) {
    pageControl.currentPage = currentPage
  }
  
  private func setButtonVisibility() {
    if pageControl.currentPage == 3 {
      signInButton.layer.isHidden = false
      signUpButton.layer.isHidden = false
    } else {
      signInButton.layer.isHidden = true
      signUpButton.layer.isHidden = true
    }
    
  }
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setConfig()
    setLayout()
    setScrollContentView()
  }
}

// MARK: - Extensions

extension LandingPageViewController: UIScrollViewDelegate {
  
  // MARK: - Scroll Helper
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let size = scrollView.contentOffset.x / scrollView.frame.size.width
    selectedPage(currentPage: Int(round(size)))
    setButtonVisibility()
  }
}

extension LandingPageViewController {
  
  // MARK: - Layout Helper
  
  private func setConfig() {
    view.backgroundColor = .gray050
    [logoImageView, scrollView, pageControl, signUpButton, signInButton].forEach {
      view.addSubview($0)
    }
  }
  
  private func setLayout() {
    let guide = self.view.safeAreaLayoutGuide
    
    logoImageView.snp.makeConstraints {
      $0.centerX.equalTo(guide)
      $0.top.equalTo(guide).offset(Constant.navigationBarHeight.adjusted)
      $0.leading.trailing.equalTo(guide).inset(Constant.logoWidth.adjusted)
      $0.height.equalTo(Constant.logoHeight.adjusted)
    }
    
    scrollView.snp.makeConstraints {
      $0.top.equalTo(logoImageView.snp.bottom).offset(Constant.logoBottomMargin.adjusted)
      $0.centerX.equalTo(guide)
      $0.leading.trailing.equalTo(guide)
      $0.height.equalTo(Constant.mainImageHeight)
    }
    
    pageControl.snp.makeConstraints {
      $0.top.equalTo(scrollView.snp.bottom).offset(Constant.bottomMargin.adjusted)
      $0.centerX.equalTo(guide)
      $0.width.equalTo(Constant.pageControlWidth)
      $0.height.equalTo(Constant.pageControlHeight)
    }
    
    signUpButton.snp.makeConstraints {
      $0.top.equalTo(pageControl.snp.bottom).offset(Constant.landingBarBottomMargin.adjusted)
      $0.leading.trailing.equalTo(guide).inset(Constant.buttonWidth)
      $0.height.equalTo(Constant.buttonHeight)
    }
    
    signInButton.snp.makeConstraints {
      $0.top.equalTo(signUpButton.snp.bottom).offset(Constant.buttonBottomMargin.adjusted)
      $0.leading.trailing.equalTo(signUpButton)
      $0.height.equalTo(Constant.buttonHeight)
    }
  }
  
}
