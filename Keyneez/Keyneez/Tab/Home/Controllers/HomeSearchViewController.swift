//
//  HomeSearchViewController.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/09.
//

import UIKit
import SnapKit
import Then

final class HomeSearchViewController: NiblessViewController, NavigationBarProtocol {
  var searchContentList: [SearchContentResponseDto] = []
  private var repository: ContentRepository = KeyneezContentRepository()
  
  var searchDatasource: [SearchContentResponseDto] = []

  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .textfield(configure: (placeholder: "제목, 키워드", completion: { [self] keyword in
    guard let token = UserSession.shared.accessToken else { return }
    repository.getSearchContent(token: token, keyword: keyword!) {
         [weak self] arr in
         guard let self else {return}
         self.searchDatasource = arr
      
         DispatchQueue.main.async {
           self.homeSearchCollectionView.reloadData()
         }
       }
  }))]).build()
  private lazy var searchButton: UIButton = .init(primaryAction: didSearch).then {
    $0.setBackgroundImage(UIImage(named: "ic_search"), for: .normal)
  }
  private lazy var backButton: UIButton = .init(primaryAction: touchUpBackButton).then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback_search"), for: .normal)
  }
  private lazy var didSearch: UIAction = .init(handler: { _ in print("hi") })
  
  private lazy var touchUpBackButton: UIAction = .init(handler: { _ in
    self.navigationController?.popViewController(animated: true)
  })
  var contentView: UIView = UIView()
  private lazy var searchResultCountingLabel: UILabel = .init().then {
    $0.font = .font(.pretendardSemiBold, ofSize: 14)
  }
  // MARK: - CollectionView
  private lazy var homeSearchCollectionView: UICollectionView = {
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
  
  final let homeSearchInset: UIEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 23)
  final let homeSearchLineSpacing: CGFloat = 8
  final let homeSearchInterItemSpacing: CGFloat = 8
  final let homeSearchCellHeight: CGFloat = 240

  override func viewDidLoad() {
    super.viewDidLoad()
    setLayout()
    register()
    addNavigationViewToSubview()
  }
}

extension HomeSearchViewController {
  private func setLayout() {
    contentView.addSubviews(searchResultCountingLabel, homeSearchCollectionView)
    searchResultCountingLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(36)
      $0.centerX.equalToSuperview()
    }
    homeSearchCollectionView.snp.makeConstraints {
      $0.top.equalTo(searchResultCountingLabel.snp.bottom).offset(16)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  private func calculateCellHeight() -> CGFloat {
    let count = CGFloat(homeSearchList.count)
    let heightCount = count / 2 + count.truncatingRemainder(dividingBy: 2)
    return heightCount * homeSearchCellHeight + (heightCount - 1) * homeSearchLineSpacing + homeSearchInset.top + homeSearchInset.bottom
  }
  private func register() {
    homeSearchCollectionView.register(
      HomeSearchCollectionViewCell.self,
      forCellWithReuseIdentifier: HomeSearchCollectionViewCell.identifier)
  }
  private func updateSearchResults() {
    homeSearchCollectionView.performBatchUpdates({
        if !searchDatasource.isEmpty {
          searchDatasource = []
        }
      setSearchResultCountingLabel(count: searchDatasource.count)
      searchDatasource.enumerated().forEach {
        homeSearchCollectionView.insertItems(at: [IndexPath(item: $0.offset, section: 0)])
      }
    })
  }
  private func setSearchResultCountingLabel(count: Int) {
    let text = NSMutableAttributedString()
    text.append(NSAttributedString(string: "검색결과 ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray900]))
    text.append(NSAttributedString(string: "\(count)개", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mint500]))
    searchResultCountingLabel.attributedText = text
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeSearchViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenWidth = UIScreen.main.bounds.width
    let doubleCellWidth = screenWidth - homeSearchInset.left - homeSearchInset.right - homeSearchInterItemSpacing
    return CGSize(width: doubleCellWidth / 2, height: homeSearchCellHeight)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return homeSearchLineSpacing
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return homeSearchInterItemSpacing
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return homeSearchInset
  }
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    
    return true
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSearchCollectionViewCell.identifier, for: indexPath)
    guard let token = UserSession.shared.accessToken else { return }
    let cotentId = searchDatasource[indexPath.row].contentKey
    repository.getDetailContent(token: token, contentId: cotentId) {
         [weak self] arr in
         guard let self else { return }
//         self.searchDatasource = arr
//      print(arr)
//         DispatchQueue.main.async {
//           self.homeSearchCollectionView.reloadData()
//         }
      self.pushToContentDetailView(model: arr)
       }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeSearchViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searchDatasource.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let homeSearchCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HomeSearchCollectionViewCell.identifier, for: indexPath)
            as? HomeSearchCollectionViewCell else { return UICollectionViewCell() }
    homeSearchCell.bindHomeSearchData(model: searchDatasource[indexPath.item])
    return homeSearchCell
  }
}
