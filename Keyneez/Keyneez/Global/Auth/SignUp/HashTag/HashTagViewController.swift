//
//  hashTagViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/08.
//

import UIKit
import SnapKit
import Then

private struct Constant {
  static let collectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
  static let collectionLineSpacing: CGFloat = 8
  static let collectionItemSpacing: CGFloat = 7
  static let collectionHeight: CGFloat = 72
}

final class HashTagViewController: NiblessViewController, NavigationBarProtocol {
  
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .flexibleBox]).build()

  var contentView = UIView()
  
  private lazy var backButton: UIButton = .init(primaryAction: touchUpBackButton).then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback_search"), for: .normal)
  }
  private lazy var touchUpBackButton: UIAction = .init(handler: { _ in
    self.navigationController?.popViewController(animated: true)
  })
  
  // MARK: - UI Components
  lazy var selectedIndex = [Int]()
    
  private lazy var titleLabel: UILabel = .init().then {
    $0.text = "관심있는 해시태그에\n체크해주세요"
    $0.font = .font(.pretendardBold, ofSize: 24)
    $0.numberOfLines = 0
  }
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.isScrollEnabled = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.delegate = self
    collectionView.dataSource = self
    return collectionView
  }()
  
  private lazy var nextButton: UIButton = .init().then {
    $0.keyneezButtonStyle(style: .blackUnact, title: "다음으로")
    $0.addTarget(self, action: #selector(touchUpNextVC), for: .touchUpInside)
  }
  
  @objc
  private func touchUpNextVC() {
    pushToNextVC(VC: JellyProductViewController())
  }
  
  private let clickCountLabel: UILabel = .init().then {
    $0.textColor = .gray050
    $0.text = "0"
    $0.font = .font(.pretendardBold, ofSize: 16)
  }
  
  private let allCountLabel: UILabel = .init().then {
    $0.textColor = .gray050
    $0.text = "/3"
    $0.font = .font(.pretendardBold, ofSize: 16)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addNavigationViewToSubview()
    setConfig()
    register()
    setLayout()
  }
}

// MARK: - Extensions

extension HashTagViewController {
  
  // MARK: - Layout Helpers
  
  private func setConfig() {
    view.backgroundColor = .gray050
    [titleLabel, collectionView, nextButton].forEach {
      contentView.addSubview($0)
    }
    [clickCountLabel, allCountLabel].forEach {
      nextButton.addSubview($0)
    }
  }
  private func setLayout() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(SignUpConstant.labelTop)
      $0.leading.equalToSuperview().offset(SignUpConstant.labelLeading)
    }
    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(SignUpConstant.propensityBottomMargin)
      $0.leading.trailing.equalToSuperview().inset(Constant.collectionInset.left)
      $0.height.equalTo(calculateCellHeight())
    }
    nextButton.snp.makeConstraints {
      $0.top.equalTo(collectionView.snp.bottom).offset(38)
      $0.height.equalTo(SignUpConstant.buttonHeight)
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(SignUpConstant.labelTop)
    }
    allCountLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(14)
    }
    clickCountLabel.snp.makeConstraints {
      $0.trailing.equalTo(allCountLabel.snp.leading)
      $0.centerY.equalTo(allCountLabel)
    }
  }
  private func calculateCellHeight() -> CGFloat {
    let count = CGFloat(hashTagData.count)
    let heightCount = count / 2 + count.truncatingRemainder(dividingBy: 2)
    return heightCount * Constant.collectionHeight + (heightCount - 1) * Constant.collectionLineSpacing
    
  }
  private func register() {
    collectionView.register(HashTagCollectionViewCell.self, forCellWithReuseIdentifier: HashTagCollectionViewCell.identifier)
  }
}

extension HashTagViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenWidth = UIScreen.main.bounds.width
    let doubleCellWidth = screenWidth - Constant.collectionInset.left - Constant.collectionInset.right - Constant.collectionItemSpacing
    return CGSize(width: doubleCellWidth / 2, height: Constant.collectionHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return Constant.collectionLineSpacing
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return Constant.collectionItemSpacing
  }
}

extension HashTagViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hashTagData.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: HashTagCollectionViewCell.identifier, for: indexPath) as? HashTagCollectionViewCell else { return UICollectionViewCell() }
    collectionCell.dataBind(model: hashTagData[indexPath.item])
    return collectionCell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let cell = collectionView.cellForItem(at: indexPath) as? HashTagCollectionViewCell
    
    if cell?.indexView.isHidden == true {
      
      if selectedIndex.count < 3 {
        selectedIndex.append(indexPath.row)
        guard let index = selectedIndex.firstIndex(of: indexPath.row) else { return }
        cell?.selectView(index: index)
        clickCountLabel.text = String(selectedIndex.count)
        
      }
    } else {
      guard let index = selectedIndex.firstIndex(of: indexPath.item) else { return }
      selectedIndex.remove(at: index)
      cell?.unSelectiView()
      selectedIndex.forEach {
        let cell = collectionView.cellForItem(at: [0, $0]) as? HashTagCollectionViewCell
        guard let newIndex = selectedIndex.firstIndex(of: $0) else {
          return }
        cell?.changeIndexLabel(index: newIndex)
      }
      clickCountLabel.text = String(selectedIndex.count)
    }
    if selectedIndex.count == 3 {
      nextButton.keyneezButtonStyle(style: .blackAct, title: "다음으로")
      allCountLabel.textColor = .mint500
      clickCountLabel.textColor = .mint500
    } else {
      nextButton.keyneezButtonStyle(style: .blackUnact, title: "다음으로")
      allCountLabel.textColor = .gray050
      clickCountLabel.textColor = .gray050
    }
  }
}
