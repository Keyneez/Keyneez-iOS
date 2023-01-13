//
//  simplePwdViewController.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/10.
//

import UIKit
import SnapKit
import Toast
import Then

private struct Constant {
  static let titleTop: CGFloat = 12
  static let imageTop: CGFloat = 31
  static let imageLeading: CGFloat = 88
  static let imageHeight: CGFloat = 20
  static let collectionLeading: CGFloat = 16
  static let collectionBottom: CGFloat = 48
  static let imageBottom: CGFloat = 151
  static let cellHeight: CGFloat = 90
  static let cellInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  static let imageArray: [String] = ["pwd0", "pwd1", "pwd2", "pwd3", "pwd4", "pwd5", "pwd6"]
  static var index: Int = 0

}
class SimplePwdCheckViewController: NiblessViewController, NavigationBarProtocol {

  lazy var navigationView: UIView = NavigationViewBuilder(barViews: [.iconButton(with: backButton), .flexibleBox]).build()
  
  private lazy var backButton: UIButton = .init(primaryAction: touchUpBackButton).then {
    $0.setBackgroundImage(UIImage(named: "ic_arrowback_search"), for: .normal)
  }
  private lazy var touchUpBackButton: UIAction = .init(handler: { _ in
    self.navigationController?.popViewController(animated: true)
  })
  
  var contentView = UIView()
  
  private let titleLabel: UILabel = .init().then {
    $0.text = "설정한 비밀번호를\n한번 더 입력해주세요"
    $0.font = .font(.pretendardBold, ofSize: 24)
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  private let progressImageView: UIImageView = .init().then {
    $0.image = UIImage(named: Constant.imageArray[0])
    $0.contentMode = .scaleAspectFit
  }
  
  private let checkImageView: UIImageView = .init().then {
    $0.image = UIImage(named: "unselect")
    $0.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
  }
  private let checkLabel: UILabel = .init().then {
    $0.text = "Face ID 사용하기"
    $0.font = .font(.pretendardMedium, ofSize: 16)
    $0.textColor = .gray900
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addNavigationViewToSubview()
    setConfig()
    register()
    setLayout()
  }
  
  var password: String = ""
  var userData: ProductJellyResponseDto?
  func dataBind(pwd: String, userData: ProductJellyResponseDto) {
    password = pwd
    self.userData = userData
  }
  
  private var selectedNumber:[Int] = []
  
  private func passwordInfo(token: String, with dto: ProductPwdRequestDto, completion: @escaping(ProductPwdResponseDto) -> Void) {
    UserAPIProvider.shared.patchPwdInfo(token: token, param: dto) { [weak self] result in
      guard let self else {return}
      switch result {
      case .success(let data):
        guard let userData = self.userData else {return}
        UserSession.shared.profile = Profile(name: userData.userName, birthday: userData.userBirth, userCharacter: userData.characters?.character, userPhoneNumber: userData.userPhone)
        DispatchQueue.main.async {
          self.view.window?.rootViewController = KeyneezTabbarController()
                  }
      case .failure(let error):
        print(error)
      }
    }
  }
}

extension SimplePwdCheckViewController {
  private func setConfig() {
    view.backgroundColor = .gray050
    [titleLabel, progressImageView, collectionView].forEach {
      contentView.addSubview($0)
    }

  }
  private func setLayout() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Constant.titleTop.adjusted)
      $0.centerX.equalToSuperview()
    }
    progressImageView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Constant.imageTop.adjusted)
      $0.leading.trailing.equalToSuperview().inset(Constant.imageLeading.adjusted)
      $0.height.equalTo(Constant.imageHeight.adjusted)
    }
    collectionView.snp.makeConstraints {
      $0.top.equalTo(progressImageView.snp.bottom).offset(Constant.imageBottom.adjusted)
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(Constant.collectionLeading.adjusted)
      $0.height.equalTo(calculateCellHeight())
      $0.bottom.equalToSuperview().inset(Constant.collectionBottom.adjusted)
    }
  }
  private func calculateCellHeight() -> CGFloat {
    let count = CGFloat(pwdNumberData.count)
    let heightCount = count / 3 + count.truncatingRemainder(dividingBy: 2)
    return heightCount * Constant.cellHeight
  }
  private func register() {
    collectionView.register(SimplePwdCollectionViewCell.self, forCellWithReuseIdentifier: SimplePwdCollectionViewCell.identifier)
  }
}

extension SimplePwdCheckViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenWidth = UIScreen.main.bounds.width
    let cellWidth = screenWidth - 32
    return CGSize(width: cellWidth / 3, height: Constant.cellHeight)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return Constant.cellInset
  }
}

extension SimplePwdCheckViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pwdNumberData.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimplePwdCollectionViewCell.identifier, for: indexPath)
             as? SimplePwdCollectionViewCell else {return UICollectionViewCell() }
      cell.dataBind(model: pwdNumberData[indexPath.item])
    
    if indexPath.item == 9 {
      cell.number.font = .font(.pretendardBold, ofSize: 16)
      cell.number.textColor = .gray500
    }
    if indexPath.item == 11 {
      cell.backImageView.isHidden = false
    }
     return cell
 }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // 간편 비밀번호 로직
    
    if indexPath.item != 11 && indexPath.item != 9 {
      selectedNumber.append(Int(pwdNumberData[indexPath.row].text)!)
      Constant.index += 1
      switch Constant.index {
      case 1:
        progressImageView.image = UIImage(named: Constant.imageArray[1])
      case 2:
        progressImageView.image = UIImage(named: Constant.imageArray[2])
      case 3:
        progressImageView.image = UIImage(named: Constant.imageArray[3])
      case 4:
        progressImageView.image = UIImage(named: Constant.imageArray[4])
      case 5:
        progressImageView.image = UIImage(named: Constant.imageArray[5])
      case 6:
        progressImageView.image = UIImage(named: Constant.imageArray[6])
        let passwordArray = selectedNumber.map { String($0) }
        //처음 입력한 비밀번호와 체크 비밀번호가 같을때
        if password == passwordArray.joined() {
          guard let token = UserSession.shared.accessToken else {return}
          var pwdInfoRequsetDto = ProductPwdRequestDto(userPassword: password)
          passwordInfo(token: token, with: pwdInfoRequsetDto) { _ in }
          
        }else {
          view.makeToast("비밀번호가 일치하지 않습니다.\n         다시 입력해주세요.", duration: 0.8, position: .center)
          selectedNumber.removeAll()
          Constant.index = 0
          progressImageView.image = UIImage(named: Constant.imageArray[0])
        }
        
        var pwdInfoRequsetDto = ProductPwdRequestDto(userPassword: password)
        guard let token = UserSession.shared.accessToken else {return}
        passwordInfo(token: token, with: pwdInfoRequsetDto) { _ in }
      default:
        return
      }
      
    } else {
      
      if Constant.index > 0 && Constant.index < 7 {
        Constant.index -= 1
        progressImageView.image = UIImage(named: Constant.imageArray[Constant.index])
        
        switch  indexPath.item {
        case 11:
          selectedNumber.removeLast()
        case 9:
          // TODO: - 재배열 코드 넣어주기
          return
        default:
          return
        }
  
      } else if Constant.index < 0 {Constant.index = 0}
      else if Constant.index > 6 {Constant.index = 6}
    }
    
    print(selectedNumber)
  }
}
