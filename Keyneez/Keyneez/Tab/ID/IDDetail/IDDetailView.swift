//
//  IDDetailView.swift
//  Keyneez
//
//  Created by Jung peter on 1/4/23.
//

import UIKit

struct DetailID: Codable {
  var personType: String
  var name: String
  var school: String?
  var birth: String
}

private struct Constant {
  static let buttonTitle = "실물인증"
  static let imageviewName = "id_mark"
  static let personTypeLabelOffset: (top: CGFloat, leading: CGFloat, bottom: CGFloat) = (6, 37, -5)
  static let ImageLogoViewOffset: (top: CGFloat, trailing: CGFloat, height: CGFloat) = (34, -36, 64)
  static let seperatedViewOffset: (top: CGFloat, bottom: CGFloat) = (22, -20)
  static let highSchoolLabelBottomOffset: CGFloat = -5
  static let authenticateButton: (top: CGFloat, leading: CGFloat, bottom: CGFloat) = (79, 16, -44)
  static let authenticateButtonHeight: CGFloat = 48
}

final class IDdetailView: NiblessView {
  
  // Actions
  let actions: IDDetailActionables
  
  private lazy var personTypeLabel: UILabel = .init().then {
    $0.font = .font(.pretendardMedium, ofSize: 12)
    $0.text = "호기심 가득 문화인"
  }
  
  private lazy var nameLabel: UILabel = .init().then {
    $0.font = .font(.pretendardBold, ofSize: 28)
    $0.textColor = .gray900
    $0.text = "김민지"
  }
  
  private lazy var keyneezLogoImageView: UIImageView = .init().then {
    $0.image = UIImage(named: Constant.imageviewName)!
  }
  
  private lazy var seperatedView: UIView = .init().then {
    $0.backgroundColor = .gray300
  }
  
  private lazy var highSchoolLabel: UILabel = makeDetailLabel(text: "키니즈 고등학교")
  
  private lazy var birthdayLabel: UILabel = makeDetailLabel(text: "2001.01.17")
  
  private lazy var authenticateButton: UIButton = .init().then {
    $0.keyneezButtonStyle(style: .blackAct,
                          title: Constant.buttonTitle,
                          action: actions.touchAuthentication(to: makePhysicalIDViewController()))
  }
  
  init(frame: CGRect, actions: IDDetailActionables) {
    self.actions = actions
    super.init(frame: frame)
    addsubview()
    setConstraints()
    self.backgroundColor = .white
  }
  
}

// MARK: - UI

extension IDdetailView {
  
  private func makePhysicalIDViewController() -> PhysicalIDViewController {
    return PhysicalIDViewController()
  }
  
  private func makeDetailLabel(text: String) -> UILabel {
    return UILabel().then {
      $0.text = text
      $0.font = .font(.pretendardMedium, ofSize: 16)
      $0.textColor = .gray900
    }
  }
  
  private func addsubview() {
    [personTypeLabel, keyneezLogoImageView, nameLabel, seperatedView, highSchoolLabel, birthdayLabel, authenticateButton].forEach { self.addSubview($0) }
  }
  
  private func setConstraints() {
    
    personTypeLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(Constant.personTypeLabelOffset.leading)
      $0.top.equalTo(keyneezLogoImageView.snp.top).offset(Constant.personTypeLabelOffset.top)
      $0.bottom.equalTo(nameLabel.snp.top).offset(Constant.personTypeLabelOffset.bottom)
    }
    
    nameLabel.snp.makeConstraints {
      $0.leading.equalTo(personTypeLabel)
    }
    
    keyneezLogoImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Constant.ImageLogoViewOffset.top)
      $0.trailing.equalToSuperview().offset(Constant.ImageLogoViewOffset.trailing)
      $0.height.width.equalTo(Constant.ImageLogoViewOffset.height)
    }
    
    seperatedView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.top.equalTo(nameLabel.snp.bottom).offset(Constant.seperatedViewOffset.top)
      $0.leading.equalTo(personTypeLabel.snp.leading)
      $0.trailing.equalTo(keyneezLogoImageView.snp.trailing)
      $0.bottom.equalTo(highSchoolLabel.snp.top).offset(Constant.seperatedViewOffset.bottom)
    }
    
    highSchoolLabel.snp.makeConstraints {
      $0.leading.equalTo(personTypeLabel.snp.leading)
      $0.bottom.equalTo(birthdayLabel.snp.top).offset(Constant.highSchoolLabelBottomOffset)
    }
    
    birthdayLabel.snp.makeConstraints {
      $0.leading.equalTo(highSchoolLabel.snp.leading)
    }
    
    authenticateButton.snp.makeConstraints {
      $0.top.equalTo(birthdayLabel.snp.bottom).offset(Constant.authenticateButton.top)
      $0.leading.trailing.equalToSuperview().inset(Constant.authenticateButton.leading)
      $0.height.equalTo(Constant.authenticateButtonHeight)
      $0.bottom.equalToSuperview().offset(Constant.authenticateButton.bottom)
    }
    
  }
  
}
