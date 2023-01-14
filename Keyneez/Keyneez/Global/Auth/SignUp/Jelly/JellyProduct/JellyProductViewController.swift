//
//  JellyProductViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/09.
//

import UIKit
import SnapKit
import Then

// TODO: - 2개만 선택되게 !!!!!
class JellyProductViewController: NiblessViewController, NavigationBarProtocol {
 
  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.flexibleBox]).build()
   var contentView = UIView()
   
   private lazy var backButton: UIButton = .init(primaryAction: touchUpBackButton).then {
     $0.setBackgroundImage(UIImage(named: "ic_arrowback_search"), for: .normal)
   }
   private lazy var touchUpBackButton: UIAction = .init(handler: { _ in
     self.navigationController?.popViewController(animated: true)
   })
  
  // MARK: - UI Components
  
  
  private let titleLabel: UILabel = .init().then {
    $0.text = "김민지님의 젤리는"
    $0.font = .font(.pretendardSemiBold, ofSize: 20)
    $0.textColor = .gray500
  }
  private let subTitleLabel: UILabel = .init().then {
    $0.text = "호기심 많은 문화인"
    $0.font = UIFont.font(.pretendardBold, ofSize: 28)
    $0.textColor = .gray900
  }
  private lazy var detailButton: UIButton = .init().then {
    $0.setImage(UIImage(named: "ic_arrowback_right"), for: .normal)
    $0.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
  }
  
  private let detailStackView: UIStackView = .init().then {
    $0.axis = .horizontal
    $0.isUserInteractionEnabled = true
    $0.distribution = .equalSpacing
  }
  
  @objc
  func touchUpStackView() {
      let tap = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
      detailStackView.addGestureRecognizer(tap)
  }
  
  @objc
  private func stackViewTapped() {
    pushToNextVC(VC: JellyDetailBottomSheetViewController())
    
  }
  
  private lazy var jellyImageView: UIImageView = .init().then {
    $0.image = UIImage(named: "jelly_mint")
    $0.contentMode = .scaleAspectFill
  }
  
  private let itemLabel: UILabel = .init().then {
    $0.text = "나의 아이템"
    $0.font = .font(.pretendardBold, ofSize: 14)
    $0.textColor = .gray900
  }
  private let itemCountLabel: UILabel = .init().then {
    $0.text = " 10"
    $0.textColor = .mint500
    $0.font = .font(.pretendardBold, ofSize: 14)
  }
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.isScrollEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.delegate = self
    collectionView.dataSource = self
    return collectionView
  }()
  
  private lazy var startButton: UIButton = .init(primaryAction: nil).then {
    $0.keyneezButtonStyle(style: .blackAct, title: "키니즈 시작하기")
    $0.addTarget(self, action: #selector(touchUpNextVC), for: .touchUpInside)
  }
  
  var userData: ProductJellyResponseDto?
  func dataBind(data: ProductJellyResponseDto) {
    self.userData = data
  }
  
  @objc
  private func touchUpNextVC() {
    let nextVC = SimplePwdViewController()
    guard let userData = userData else {return}
    nextVC.dataBind(data: userData)
    pushToNextVC(VC: nextVC)
  }
  
  private func setText() {
    guard let userData = self.userData else {return}
    subTitleLabel.text = userData.characters?.character
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    addNavigationViewToSubview()
    setConfig()
    register()
    setLayout()
    touchUpStackView()
    print(userData)
  }
}

// MARK: - Extensions

extension JellyProductViewController {
  
  // MARK: - Layout Helpers
  
  private func setConfig() {
    view.backgroundColor = .gray050
    [titleLabel, detailStackView, jellyImageView, itemLabel, itemCountLabel, collectionView, startButton].forEach {
      contentView.addSubview($0)
    }
    [subTitleLabel, detailButton].forEach {
      detailStackView.addArrangedSubview($0)
    }
    
  }
  private func register() {
    collectionView.register(JellyProductCollectionViewCell.self, forCellWithReuseIdentifier: JellyProductCollectionViewCell.identifier)
  }
  private func setLayout() {
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(SignUpConstant.labelTop)
      $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(SignUpConstant.labelLeading)
    }
    detailStackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.leading.equalTo(titleLabel)
      $0.height.equalTo(33)
    }
    jellyImageView.snp.makeConstraints {
      $0.top.equalTo(detailStackView.snp.bottom).offset(50)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalTo(290)
    }
    itemLabel.snp.makeConstraints {
      $0.top.equalTo(jellyImageView.snp.bottom).offset(28)
      $0.leading.equalToSuperview().offset(16)
    }
    itemCountLabel.snp.makeConstraints {
      $0.top.bottom.equalTo(itemLabel)
      $0.leading.equalTo(itemLabel.snp.trailing)
    }
    collectionView.snp.makeConstraints {
      $0.top.equalTo(itemLabel.snp.bottom).offset(12)
      $0.leading.equalTo(itemLabel)
      $0.trailing.equalToSuperview()
      $0.height.equalTo(88)
    }
    startButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(SignUpConstant.buttonBottom.adjusted)
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(SignUpConstant.labelTop)
      $0.height.equalTo(SignUpConstant.buttonHeight.adjusted)
    }
  }
}
extension JellyProductViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 88, height: 88)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 12
  }
  
}
extension JellyProductViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return jellyIconData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JellyProductCollectionViewCell.identifier, for: indexPath)
              as? JellyProductCollectionViewCell else { return UICollectionViewCell() }
      cell.dataBind(model: jellyIconData[indexPath.item])

      return cell
    }
      }
