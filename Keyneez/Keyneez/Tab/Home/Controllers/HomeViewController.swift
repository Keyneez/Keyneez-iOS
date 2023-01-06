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
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.logo, .flexibleBox, .iconButton(with: searchButton)]).build()
  private lazy var searchButton: UIButton = .init(primaryAction: didSearch).then {
    $0.setBackgroundImage(UIImage(named: "ic_search"), for: .normal)
  }
  private var didSearch: UIAction = .init(handler: { _ in print("hi")})
  lazy var contentView: UIView = UIView()
  
  // MARK: - SegmentedControl Control
  private lazy var containerView: UIView = .init().then {
    $0.backgroundColor = .clear
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  private lazy var segmentControl: UISegmentedControl = .init().then {
    $0.selectedSegmentTintColor = .clear
    $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
    $0.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    $0.insertSegment(withTitle: "추천", at: 0, animated: true)
    $0.insertSegment(withTitle: "인기", at: 1, animated: true)
    $0.insertSegment(withTitle: "최신", at: 2, animated: true)
    $0.selectedSegmentIndex = 0
    $0.setTitleTextAttributes([
      NSAttributedString.Key.foregroundColor: UIColor.gray400,
      NSAttributedString.Key.font: UIFont.font(.pretendardMedium, ofSize: 24)
    ], for: .normal)
    $0.setTitleTextAttributes([
      NSAttributedString.Key.foregroundColor: UIColor.gray900,
      NSAttributedString.Key.font: UIFont.font(.pretendardBold, ofSize: 24)
    ], for: .selected)
    $0.addTarget(self, action: #selector(changeUnderLinePosition), for: .valueChanged)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  // MARK: - Underline View
  private lazy var underLineView: UIView = .init().then {
    $0.backgroundColor = .gray900
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  // MARK: - CollectionView
  private lazy var homeContentCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.isScrollEnabled = true
    collectionView.showsVerticalScrollIndicator = false
    collectionView.delegate = self
    collectionView.dataSource = self
    return collectionView
  }()
  
  var homeContentList: [HomeContentModel] = [
    HomeContentModel(contentImage: "", start_at: "11.24", end_at: "12.31", contentTitle: "청소년 미술관 할인", introduction: "어쩌구저쩌구", categoty: ["문화"], liked: false),
    HomeContentModel(contentImage: "", start_at: "12.31", end_at: "01.01", contentTitle: "예시입니당", introduction: "어쩌구저쩌구", categoty: ["문화", "예술"], liked: true)]
  
  final let homeContentInset: UIEdgeInsets = UIEdgeInsets(top: 32, left: 17, bottom: 20, right: 17)
  final let homeContentLineSpacing: CGFloat = 16
  final let homeContentCellHeight: CGFloat = 400
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setLayout()
    register()
    addNavigationViewToSubview()
  }
}

// MARK: - extra functions
extension HomeViewController {
  private func setLayout() {
    homeContentCollectionView.backgroundColor = .systemBlue
    contentView.addSubviews(containerView, homeContentCollectionView)
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
    homeContentCollectionView.snp.makeConstraints {
      $0.top.equalTo(underLineView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(calculateCellHeight())
    }
//    homeContentCollectionView.backgroundColor = .gray500
  }
  @objc private func changeUnderLinePosition() {
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
  
  private func calculateCellHeight() -> CGFloat {
    let count = CGFloat(homeContentList.count)
    return count * homeContentCellHeight + (count-1) * homeContentLineSpacing + homeContentInset.top + homeContentInset.bottom
  }
  
  private func register() {
    homeContentCollectionView.register(
      HomeContentCollectionViewCell.self,
      forCellWithReuseIdentifier: HomeContentCollectionViewCell.identifier)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenWidth = UIScreen.main.bounds.width
    let CellWidth = screenWidth - homeContentInset.left - homeContentInset.right
    return CGSize(width: CellWidth, height: 400)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return homeContentLineSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return homeContentInset
  }
}

// MARK: -UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return homeContentList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let homeContentCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeContentCollectionViewCell.identifier, for: indexPath)
            as? HomeContentCollectionViewCell else { return UICollectionViewCell() }
    homeContentCell.dataBind(model: homeContentList[indexPath.item])
    return homeContentCell
  }
}
