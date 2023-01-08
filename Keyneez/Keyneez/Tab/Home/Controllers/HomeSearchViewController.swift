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
  private lazy var searchCollectionView: UICollectionView = {
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
  override func viewDidLoad() {
    super.viewDidLoad()
    setLayout()
    addNavigationViewToSubview()
  }
}

extension HomeSearchViewController {
  private func setLayout() {
    contentView.addSubviews(searchResultCountingLabel)
    searchResultCountingLabel.snp.makeConstraints{
      $0.top.equalToSuperview().inset(36)
      $0.centerX.equalToSuperview()
    }
  }
}
