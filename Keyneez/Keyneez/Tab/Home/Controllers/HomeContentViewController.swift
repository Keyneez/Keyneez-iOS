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
  var contentList: [HomeContentResponseDto] = []
  private var repository: ContentRepository = KeyneezContentRepository()

  // MARK: - CollectionView
  lazy var recommendContentCollectionView: UICollectionView = {
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
    floatyFilter.isHidden = true
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
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let token = UserSession.shared.accessToken else { return }
    let cotentId = contentList[indexPath.row].contentKey
    repository.getDetailContent(token: token, contentId: cotentId) {
      [weak self] arr in
      guard let self else { return }
      self.pushToContentDetailView(model: arr)
    }
  }
}

// MARK: - UICollectionViewDataSource

extension HomeContentViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return contentList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let homeContentCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeContentCollectionViewCell.identifier, for: indexPath)
            as? HomeContentCollectionViewCell else { return UICollectionViewCell() }
    
    homeContentCell.bindHomeData(model: contentList[indexPath.item])
    // 여기서 setCategory
    homeContentCell.setHomeCategoryCard(category: contentList[indexPath.item].category[0])
    return homeContentCell
  }
}
