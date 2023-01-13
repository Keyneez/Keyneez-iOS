//
//  LikeViewController.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/02.
//

import UIKit

final class LikeViewController: NiblessViewController, NavigationBarProtocol {
  let repository: ContentRepository = KeyneezContentRepository()
  var likedContentDataSource: [MyLikedContentResponseDto] = []
  
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.button(with: myLikeButton), .flexibleBox, .iconButton(with: editButton)]).build()
  private lazy var myLikeButton: UIButton = .init(primaryAction: touchUpMyLikeButton).then {
    $0.setTitle("저장", for: .normal)
    $0.setTitleColor(.gray900, for: .normal)
    $0.titleLabel?.font = .font(.pretendardBold, ofSize: 20)
    $0.frame.size.width = 35
    $0.frame.size.height = 24
  }
  private lazy var touchUpMyLikeButton: UIAction = .init(handler: { _ in
    print("touch up my like button")
  })
  private lazy var editButton: UIButton = .init(primaryAction: touchUpEditButton).then {
    $0.setBackgroundImage(UIImage(named: "ic_edit"), for: .normal)
  }
  private lazy var touchUpEditButton: UIAction = .init { _ in
    print("touchUpEditButton")
  }
  var contentView: UIView = UIView()
  private let lineView: UIView = .init().then {
    $0.backgroundColor = .gray900
  }
  private lazy var likeCollectionView: UICollectionView = {
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
  
  final let likeInset: UIEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 23)
  final let likeLineSpacing: CGFloat = 8
  final let likeInterItemSpacing: CGFloat = 8
  final let likeCellHeight: CGFloat = 240

  override func viewDidLoad() {
    super.viewDidLoad()
    setLayout()
    register()
    addNavigationViewToSubview()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let token = UserSession.shared.accessToken else { return }
    repository.getLikedContent(token: token) {
      [weak self] result in
      guard let self else {return}
      self.likedContentDataSource = result
      DispatchQueue.main.async {
        self.likeCollectionView.reloadData()
      }
    }
  }
}

extension LikeViewController {
  private func setLayout() {
    navigationView.addSubviews(lineView)
    contentView.addSubviews(likeCollectionView)
    lineView.snp.makeConstraints {
      $0.centerX.equalTo(myLikeButton)
      $0.bottom.equalTo(myLikeButton).offset(6)
      $0.width.equalTo(32)
      $0.height.equalTo(3)
    }
    likeCollectionView.snp.makeConstraints {
      $0.leading.trailing.top.bottom.equalToSuperview()
    }
  }
  private func calculateCellHeight() -> CGFloat {
    let count = CGFloat(homeSearchList.count)
    let heightCount = count / 2 + count.truncatingRemainder(dividingBy: 2)
    return heightCount * likeCellHeight + (heightCount - 1) * likeLineSpacing + likeInset.top + likeInset.bottom
  }
  private func register() {
    likeCollectionView.register(
      HomeSearchCollectionViewCell.self,
      forCellWithReuseIdentifier: HomeSearchCollectionViewCell.identifier)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LikeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenWidth = UIScreen.main.bounds.width
    let doubleCellWidth = screenWidth - likeInset.left - likeInset.right - likeInterItemSpacing
    return CGSize(width: doubleCellWidth / 2, height: likeCellHeight)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return likeLineSpacing
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return likeInterItemSpacing
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return likeInset
  }
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//    pushToContentDetailView()
    return true
  }
}

// MARK: - UICollectionViewDataSource
extension LikeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return likedContentDataSource.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let likedContentCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeSearchCollectionViewCell.identifier, for: indexPath)
            as? HomeSearchCollectionViewCell else { return UICollectionViewCell() }
//    homeSearchCell.bindHomeSearchData(model: homeSearchList[indexPath.item])
    return likedContentCell
  }
}
