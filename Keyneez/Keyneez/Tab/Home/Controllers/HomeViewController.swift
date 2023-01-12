//
//  HomeViewController.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/02.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: NiblessViewController, NavigationBarProtocol {
  
  // MARK: - NavagationView with logo
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.logo(color: .black), .flexibleBox, .iconButton(with: searchButton)]).build()
  private lazy var searchButton: UIButton = .init(primaryAction: didSearch).then {
    $0.setBackgroundImage(UIImage(named: "ic_search"), for: .normal)
  }
  private lazy var didSearch: UIAction = .init(handler: { _ in
    let homeSearchViewController = HomeSearchViewController()
    homeSearchResults = []
    self.navigationController?.pushViewController(homeSearchViewController, animated: true)
  })
  lazy var contentView: UIView = UIView()
  
  // MARK: - SegmentedControl Control
  private lazy var containerView: UIView = .init().then {
    $0.backgroundColor = UIColor.gray050
  }
  lazy var segmentControl: UISegmentedControl = .init().then {
    $0.insertSegment(withTitle: "추천", at: 0, animated: true)
    $0.insertSegment(withTitle: "인기", at: 1, animated: true)
    $0.insertSegment(withTitle: "최신", at: 2, animated: true)
    $0.selectedSegmentIndex = 0
    $0.removeBorder()
    $0.setNormalFont(font: UIFont.font(.pretendardMedium, ofSize: 24), fontColor: .gray400)
    $0.setSelectedFont(font: UIFont.font(.pretendardBold, ofSize: 24), fontColor: .gray900)
    $0.addTarget(self, action: #selector(changeUnderLinePosition), for: .valueChanged)
  }
  // MARK: - Underline View
  private lazy var underLineView: UIView = .init().then {
    $0.backgroundColor = .gray900
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setLayout()
    addContentViews(asChildViewController: HomeContentViewController())
    addNavigationViewToSubview()
  }
  private var repository: ContentRepository = KeyneezContentRepository()
  
  var datasources: [[HomeContentResponseDto]] = [] {
    didSet {
      print(datasources)
    }
  }
  let VCs: [HomeContentViewController] = [HomeContentViewController(), HomeContentViewController(), HomeContentViewController()]
  
  override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
    guard let token = UserSession.shared.accessToken else { return }
    repository.getAllContents(token: token) {
         [weak self] arr in
         guard let self else {return}
         self.datasources.append(arr)
         DispatchQueue.main.async {
           self.VCs.forEach {
             $0.contentList = self.datasources[0]
             $0.recommendContentCollectionView.reloadData()
           }
         }
       }
    }
}

// MARK: - extra functions
extension HomeViewController {
  private func setLayout() {
    contentView.addSubviews(containerView)
    containerView.addSubviews(segmentControl, underLineView)
    containerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(48)
    }
    segmentControl.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(2)
    }
    underLineView.snp.makeConstraints {
      $0.bottom.equalTo(segmentControl).offset(6)
      $0.leading.equalTo(segmentControl).inset(15)
      $0.height.equalTo(3)
      $0.width.equalTo(32)
    }
  }
  @objc private func changeUnderLinePosition() {
    animateUnderline()
    changeViewControllers()
  }
  private func animateUnderline() {
    let segmentIndex = segmentControl.selectedSegmentIndex
    let segmentNumber = segmentControl.numberOfSegments
    self.underLineView.snp.remakeConstraints {
      $0.bottom.equalTo(segmentControl).offset(6)
      $0.leading.equalTo(segmentControl).inset(Int(self.segmentControl.frame.width) / segmentNumber * segmentIndex + 15)
      $0.height.equalTo(3)
      $0.width.equalTo(32)
    }
    UIView.animate(withDuration: 0.2, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    })
  }
  private func changeViewControllers() {
    let segmentIndex = segmentControl.selectedSegmentIndex
    var count = 0
    for VC in VCs {
      VC.segmentedNumber = count
      count += 1
    }
    remove(asChildViewController: self.children[0])
    addContentViews(asChildViewController: VCs[segmentIndex])
  }
  private func addContentViews(asChildViewController viewController: UIViewController) {
    addChild(viewController)
    let subView = viewController.view!
    contentView.addSubview(subView)
    subView.snp.makeConstraints {
      $0.top.equalTo(underLineView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    viewController.didMove(toParent: self)
  }
  private func remove(asChildViewController viewController: UIViewController) {
      viewController.willMove(toParent: nil)
      viewController.view.removeFromSuperview()
      viewController.removeFromParent()
  }
}
