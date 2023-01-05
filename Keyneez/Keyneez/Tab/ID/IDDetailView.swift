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
}

final class IDdetailView: NiblessView {
  
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
  
  private lazy var highSchoolLabel: UILabel = makeDetailLabel()
  
  private lazy var birthdayLabel: UILabel = makeDetailLabel()
  
  private lazy var authenticateButton: UIButton = .init().then {
    $0.keyneezButtonStyle(style: .blackAct,
                          title: Constant.buttonTitle,
                          action: Action.didTouchAuthenticateButton.action)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addsubview()
    setConstraints()
  }
  
}

// MARK: - State & Action

extension IDdetailView {
  
  enum Action {
    case didTouchAuthenticateButton
    
    var action: UIAction {
      switch self {
      case .didTouchAuthenticateButton:
        return UIAction(handler: { _ in print("실물인증 버튼 눌림") })
      }
    }
    
  }
  
}

// MARK: - UI

extension IDdetailView {
  
  private func makeDetailLabel() -> UILabel {
    return UILabel().then {
      $0.font = .font(.pretendardMedium, ofSize: 16)
      $0.textColor = .gray900
    }
  }
  
  private func addsubview() {
    [personTypeLabel, keyneezLogoImageView, nameLabel, seperatedView, highSchoolLabel, birthdayLabel, authenticateButton].forEach { self.addSubview($0) }
  }
  
  private func setConstraints() {
    
    personTypeLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(37)
      $0.top.equalTo(keyneezLogoImageView.snp.top).offset(6)
      $0.bottom.equalTo(nameLabel.snp.top).offset(-5)
    }
    
    nameLabel.snp.makeConstraints {
      $0.leading.equalTo(personTypeLabel)
    }
    
    keyneezLogoImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(34)
      $0.trailing.equalToSuperview().offset(-36)
      $0.height.width.equalTo(64)
    }
    
    seperatedView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.top.equalTo(nameLabel.snp.bottom).offset(22)
      $0.leading.equalTo(personTypeLabel.snp.leading)
      $0.trailing.equalTo(keyneezLogoImageView.snp.trailing)
      $0.bottom.equalTo(highSchoolLabel.snp.top).offset(20)
    }
    
    highSchoolLabel.snp.makeConstraints {
      $0.leading.equalTo(personTypeLabel.snp.leading)
      $0.bottom.equalTo(birthdayLabel.snp.top).offset(-5)
    }
    
    birthdayLabel.snp.makeConstraints {
      $0.leading.equalTo(highSchoolLabel.snp.leading)
    }
    
    authenticateButton.snp.makeConstraints {
      $0.top.equalTo(birthdayLabel.snp.bottom).offset(79)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalTo(48)
//      $0.bottom.equalToSuperview().offset(-44)
    }
    
  }
  
}
