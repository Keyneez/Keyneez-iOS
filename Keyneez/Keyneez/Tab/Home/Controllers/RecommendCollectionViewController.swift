//
//  RecommendCollectionViewController.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/07.
//

import UIKit
import Then
import SnapKit

final class RecommendCollectionViewController: UIViewController {
  
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
 
  final let homeContentInset: UIEdgeInsets = UIEdgeInsets(top: 32, left: 17, bottom: 32, right: 17)
  final let homeContentLineSpacing: CGFloat = 16
  final let homeContentCellHeight: CGFloat = 400

  override func viewDidLoad() {
    super.viewDidLoad()
    register()
    setLayout()
  }

  private func register() {
    homeContentCollectionView.register(
      HomeContentCollectionViewCell.self,
      forCellWithReuseIdentifier: HomeContentCollectionViewCell.identifier)
  }
  
  private func setLayout() {
    view.addSubviews(homeContentCollectionView)
    homeContentCollectionView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RecommendCollectionViewController: UICollectionViewDelegateFlowLayout {
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

extension RecommendCollectionViewController: UICollectionViewDataSource {
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
