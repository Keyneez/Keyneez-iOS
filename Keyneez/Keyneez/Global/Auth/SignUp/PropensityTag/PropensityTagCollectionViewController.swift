//
//  PropensityTagCollectionView.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/08.
//

import UIKit
import SnapKit
import Then

final class PropensityTagCollectionViewController: UIViewController {
  
  // MARK: - UI Components
  
  private lazy var titleLabel = UILabel().then {
    $0.text = "젤리에게 나를 소개해 주세요!\n자유시간에 나는 .."
    $0.font = .font(.pretendardBold, ofSize: 24)
    $0.numberOfLines = 0
  }
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
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
  
  private lazy var nextButton = UIButton().then {
    $0.keyneezButtonStyle(style: .blackUnact, title: "다음으로")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setConfig()
    setLayout()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    collectionView.reloadData()
  }
  
}

// MARK: - Extensions

extension PropensityTagCollectionViewController {
  
  // MARK: - Layout Helpers
  
  private func setConfig() {
    view.backgroundColor = .gray050
    [titleLabel, collectionView, nextButton].forEach {
      view.addSubview($0)
    }
  }
  private func setLayout() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(SignUpConstant.labelTop)
      $0.leading.equalToSuperview().offset(SignUpConstant.labelLeading)
    }
    collectionView.snp.makeConstraints {
      $0.centerY.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(propensityTagClickData.count * Int(SignUpConstant.propensityHeight) + Int(SignUpConstant.propensityBottomMargin) * (propensityTagClickData.count - 1))
    }
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(SignUpConstant.buttonBottom)
      $0.height.equalTo(SignUpConstant.buttonHeight)
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(SignUpConstant.labelTop)
    }
  }
  private func register() {
    collectionView.register(PropensityTagCollectionViewCell.self, forCellWithReuseIdentifier: PropensityTagCollectionViewCell.identifier)
  }
}

extension PropensityTagCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PropensityTagCollectionViewCell.identifier, for: indexPath) as? PropensityTagCollectionViewCell else {
      return .zero
    }
      cell.textLabel.text = propensityTagUnclickData[indexPath.item].text
      cell.textLabel.sizeToFit()
      let cellWidth = cell.textLabel.frame.width + 32
      return CGSize(width: cellWidth, height: SignUpConstant.propensityHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return SignUpConstant.propensityBottomMargin

  }
}

extension PropensityTagCollectionViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return propensityTagClickData.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: PropensityTagCollectionViewCell.identifier, for: indexPath) as? PropensityTagCollectionViewCell else { return UICollectionViewCell() }
    
    collectionCell.dataBind(model: propensityTagUnclickData[indexPath.item])
    return collectionCell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? PropensityTagCollectionViewCell {
      cell.contentView.backgroundColor = .gray900
      cell.textLabel.textColor = .gray050
      cell.dataBind(model: propensityTagClickData[indexPath.item])
      cell.textLabel.text = propensityTagClickData[indexPath.item].text
    }
  }
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? PropensityTagCollectionViewCell {
      cell.contentView.backgroundColor = .gray100
      cell.textLabel.textColor = .gray400
      cell.dataBind(model: propensityTagUnclickData[indexPath.item])
    }
  }
}
