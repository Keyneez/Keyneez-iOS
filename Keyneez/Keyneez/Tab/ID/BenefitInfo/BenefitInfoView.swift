//
//  BenefitInfoView.swift
//  Keyneez
//
//  Created by Jung peter on 1/5/23.
//

import UIKit

private enum Benefit: String, CaseIterable {
  
  case museum
  case castle
  case naturePark
  case amusementPark
  case transportation
  case train
  
  var description: String {
    switch self {
    case .museum:
      return "박물관, 미술관, 공원\n의 이용료 면제 혹은\n50% 내외 할인"
    case .castle:
      return "궁, 릉 50% 할인"
    case .amusementPark:
      return "유원지 30%~50%\n내외 할인"
    case .naturePark:
      return "자연 휴양림 40%\n할인"
    case .transportation:
      return "버스, 지하철\n20~40% 할인"
    case .train:
      return "철토 요금 10~30%\n할인"
    }
  }
  
}

private struct Constant {
  static let title = "청소년 혜택안내"
  static let titleFontSize: CGFloat = 24
  static let commonCellSpacing: CGFloat = 8
  static let halfCellSpacing: CGFloat = commonCellSpacing / 2
}

final class BenefitInfoView: NiblessView {
    
  private lazy var titleView: UILabel = .init().then {
    $0.textColor = .gray900
    $0.font = .font(.pretendardBold, ofSize: Constant.titleFontSize)
    $0.text = Constant.title
  }
  
  private lazy var collectionView: UICollectionView = makeCollectionView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview()
    setConstraint()
  }
  
}

// MARK: - DataSource & DelegateFlowLayout

extension BenefitInfoView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    Benefit.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BenefitCollectionViewCell.identifier, for: indexPath) as? BenefitCollectionViewCell else { return BenefitCollectionViewCell() }
    
    cell.setData(with: (title: Benefit.allCases[indexPath.item].description, Benefit.allCases[indexPath.item].rawValue))
    
    return cell
    
  }
  
}

// MARK: - Private Method

extension BenefitInfoView {
  
  private func addSubview() {
    [titleView, collectionView].forEach { self.addSubview($0) }
  }
  
  private func setConstraint() {
    titleView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(30)
      $0.leading.equalToSuperview().offset(17)
      $0.bottom.equalTo(collectionView.snp.top).offset(-40)
    }
    
    collectionView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-53)
    }
  }
  
  private func makeCollectionView() -> UICollectionView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeFlowLayout())
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.register(BenefitCollectionViewCell.self)
    return collectionView
  }
  
  private func makeFlowLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = Constant.commonCellSpacing
    layout.minimumInteritemSpacing = Constant.halfCellSpacing
    layout.sectionInset = UIEdgeInsets(top: 0, left: Constant.commonCellSpacing, bottom: 0, right: Constant.commonCellSpacing)
    layout.scrollDirection = .vertical
    let cardWidth = (UIScreen.main.bounds.size.width - Constant.commonCellSpacing * 3) / 2
    layout.itemSize = CGSize(width: cardWidth, height: cardWidth)
    return layout
  }
  
}
