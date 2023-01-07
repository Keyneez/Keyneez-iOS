//
//  HomePopularViewController.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/07.
//

import UIKit
import Then
import SnapKit

final class HomePopularViewController: UIViewController {
  
  // MARK: - CollectionView
  private lazy var popularContentCollectionView: UICollectionView = {
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
    HomeContentModel(contentImage: "", start_at: "11.24", end_at: "12.31", contentTitle: "인기뷰 이거 인기뷰", introduction: "이거 인기뷰", categoty: ["문화"], liked: false),
    HomeContentModel(contentImage: "", start_at: "12.31", end_at: "01.01", contentTitle: "예시입니당", introduction: "어쩌구저쩌구", categoty: ["문화", "예술"], liked: true)]
 
  final let homeContentInset: UIEdgeInsets = UIEdgeInsets(top: 32, left: 17, bottom: 32, right: 17)
  final let homeContentLineSpacing: CGFloat = 16
  final let homeContentCellHeight: CGFloat = 400

  override func viewDidLoad() {
    super.viewDidLoad()
    register()
    setLayout()
  }

  private func register() {
    popularContentCollectionView.register(
      HomeContentCollectionViewCell.self,
      forCellWithReuseIdentifier: HomeContentCollectionViewCell.identifier)
  }
  
  private func setLayout() {
    view.addSubviews(popularContentCollectionView)
    popularContentCollectionView.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.top.bottom.equalToSuperview()
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomePopularViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenWidth = UIScreen.main.bounds.width
    let CellWidth = screenWidth - homeContentInset.left - homeContentInset.right
    return CGSize(width: CellWidth, height: homeContentCellHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return homeContentLineSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return homeContentInset
  }
}

// MARK: -UICollectionViewDataSource

extension HomePopularViewController: UICollectionViewDataSource {
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
