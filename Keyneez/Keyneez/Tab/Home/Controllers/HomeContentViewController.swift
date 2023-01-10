//
//  HomeContentViewController.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/07.
//

import UIKit
import Then
import SnapKit
import Floaty

final class HomeContentViewController: UIViewController {
  
  var segmentedNumber: Int = -1

  // MARK: - CollectionView
  private lazy var recommendContentCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.isScrollEnabled = true
    collectionView.showsVerticalScrollIndicator = false
    collectionView.delegate = self
    collectionView.dataSource = self
    return collectionView
  }()
  private let floatyFilter = Floaty().then {
    $0.buttonColor = UIColor.gray050
    $0.buttonImage = UIImage(named: "ic_filter_floating")
  }
 
  final let homeContentInset: UIEdgeInsets = UIEdgeInsets(top: 32, left: 17, bottom: 32, right: 17)
  final let homeContentLineSpacing: CGFloat = 16
  final let homeContentCellHeight: CGFloat = 400

  override func viewDidLoad() {
    super.viewDidLoad()
    register()
    setLayout()
  }

  private func register() {
    recommendContentCollectionView.register(
      HomeContentCollectionViewCell.self,
      forCellWithReuseIdentifier: HomeContentCollectionViewCell.identifier)
  }
  
  private func setLayout() {
    view.addSubviews(recommendContentCollectionView, floatyFilter)
    recommendContentCollectionView.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.top.bottom.equalToSuperview()
    }
    floatyFilter.snp.makeConstraints {
      $0.width.height.equalTo(64)
      $0.bottom.equalTo(recommendContentCollectionView).inset(138) // tabbar height + 54
      $0.trailing.equalToSuperview().inset(9)
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeContentViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenWidth = UIScreen.main.bounds.width
    let cellWidth = screenWidth - homeContentInset.left - homeContentInset.right
    return CGSize(width: cellWidth, height: homeContentCellHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return homeContentLineSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return homeContentInset
  }
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    pushToContentDetailView()
    return true
  }
}

// MARK: - UICollectionViewDataSource

extension HomeContentViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch(segmentedNumber) {
    case 0:
      return recommendContentList.count
    case 1:
      return popularContentList.count
    case 2:
      return newestContentList.count
    default:
      return recommendContentList.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let model: [HomeContentModel]
    switch(segmentedNumber) {
    case 0:
       model = recommendContentList
    case 1:
      model = popularContentList
    case 2:
      model = newestContentList
    default:
      model = recommendContentList
    }
    guard let homeContentCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeContentCollectionViewCell.identifier, for: indexPath)
            as? HomeContentCollectionViewCell else { return UICollectionViewCell() }
    homeContentCell.bindHomeData(model: model[indexPath.item])
    return homeContentCell
  }
}
