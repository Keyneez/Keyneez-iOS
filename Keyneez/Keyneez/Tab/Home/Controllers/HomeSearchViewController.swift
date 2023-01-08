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
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .flexibleBox, .iconButton(with: searchButton)]).build()
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
  private var searchResultCountingLabel: UILabel = .init().then {
    let text = NSMutableAttributedString()
    text.append(NSAttributedString(string: "검색결과 ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray900]))
    text.append(NSAttributedString(string: "15개", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mint500]))
    $0.attributedText = text
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
    searchResultCountingLabel.snp.makeConstraints{
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
}

// MARK: - UICollectionViewDataSource
extension HomeSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeSearchList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let homeSearchCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeSearchCollectionViewCell.identifier, for: indexPath)
                as? HomeSearchCollectionViewCell else { return UICollectionViewCell() }
      homeSearchCell.bindHomeSearchData(model: homeSearchList[indexPath.item])
        return homeSearchCell
    }
}
