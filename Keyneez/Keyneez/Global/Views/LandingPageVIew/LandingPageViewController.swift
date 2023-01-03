//
//  LandingPageViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/04.
//

import UIKit
import Then

class LandingPageViewController: UIViewController {
  
  //MARK: - Variables
  
  lazy var pageViewController: UIPageViewController = {
    let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    return vc
  }()
  
  lazy var vc1: UIViewController = {
    let vc = FirstLandingPageViewController()
    return vc
  }()
  
  lazy var vc2: UIViewController = {
    let vc = SecondLandingPageViewController()
    return vc
  }()
  
  lazy var vc3: UIViewController = {
    let vc = ThirdLandingPageViewController()
    return vc
  }()
  
  lazy var vc4: UIViewController = {
    let vc = FourthLandingPageViewController()
    return vc
  }()
  
  lazy var dataViewControllers: [UIViewController] = {
    return [vc1, vc2, vc3, vc4]
  }()
  
//MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setDelegate()
    setLayout()
    
    if let firstVC = dataViewControllers.first {
      pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
  }
}

//MARK: - Extensions

extension LandingPageViewController {
  
  //MARK: - Layout Helpers
  
  private func setDelegate() {
    pageViewController.dataSource = self
    pageViewController.delegate = self
  }
  
  private func setLayout() {
    addChild(pageViewController)
    view.addSubview(pageViewController.view)
    
    pageViewController.view.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    pageViewController.didMove(toParent: self)
  }
}

extension LandingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  
  //MARK: - PageController Helpers
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
    let previousIndex = index - 1
    if previousIndex < 0 {
      return nil
    }
    return dataViewControllers[previousIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
    let nextIndex = index + 1
    if nextIndex == dataViewControllers.count {
      return nil
    }
    return dataViewControllers[nextIndex]
  }
}
