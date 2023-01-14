//
//  IDInfoEditableActionables.swift
//  Keyneez
//
//  Created by Jung peter on 1/10/23.
//

import UIKit

protocol IDInfoRepository {
  func patchIDwithOCRInSchoolID(with schoolDto: UserCheckStudentIDRequestDto, completion: @escaping(EditUserResponseDto) -> Void)
  func patchIDwithOCRInYouthID(with idDto: UserCheckYouthIDRequestDto, completion: @escaping(EditUserResponseDto) -> Void)
}

final class KeyneezIDInfoRepository: IDInfoRepository {
  
  init() { }
  
  func patchIDwithOCRInSchoolID(with schoolDto: UserCheckStudentIDRequestDto, completion: @escaping (EditUserResponseDto) -> Void) {
    guard let token = UserSession.shared.accessToken else { return }
    UserAPIProvider.shared.patchInfoWithStudentIDOCR(token: token, param: schoolDto) { result in
      switch result {
      case .success(let data):
        guard let userdata = data else  { return }
        completion(userdata)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func patchIDwithOCRInYouthID(with idDto: UserCheckYouthIDRequestDto, completion: @escaping (EditUserResponseDto) -> Void) {
    guard let token = UserSession.shared.accessToken else {return}
    UserAPIProvider.shared.patchInfoWithTeenIDOCR(token: token, param: idDto) { result in
      switch result {
      case .success(let data):
        guard let idDTO = data else {return}
        completion(idDTO)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  
}

protocol IDInfoEditableActionables {
  func dismiss() -> UIAction
  func continueWithStudentID(with factory: IDIssuedFactory, dto: UserCheckStudentIDRequestDto) -> UIAction
  func continueWithYouthID(with factory: IDIssuedFactory, dto: UserCheckYouthIDRequestDto) -> UIAction
}

final class IDInfoEditableActions: IDInfoEditableActionables {
  
  private weak var viewcontroller: NiblessViewController?
  private var repository: IDInfoRepository
  
  init(viewController: NiblessViewController, respository: IDInfoRepository) {
    self.viewcontroller = viewController
    self.repository = respository
  }
  
  func dismiss() -> UIAction {
    UIAction(handler: { [weak self] _ in
      self?.viewcontroller?.dismiss(animated: true)
    })
  }
  
  func continueWithStudentID(with factory: IDIssuedFactory, dto: UserCheckStudentIDRequestDto) -> UIAction {
    return UIAction(handler: { [weak self] _ in
      guard let self else {return}
      self.repository.patchIDwithOCRInSchoolID(with: dto) { dto in
        let vc = factory.makeIDIssuedViewController()
        vc.modalPresentationStyle = .fullScreen
        self.viewcontroller?.present(vc, animated: true)
      }
    })
  }
  
  func continueWithYouthID(with factory: IDIssuedFactory, dto: UserCheckYouthIDRequestDto) -> UIAction {
    return UIAction { [weak self] _ in
      guard let self = self else { return }
      self.repository.patchIDwithOCRInYouthID(with: dto) { dto in
        let vc = factory.makeIDIssuedViewController()
        vc.modalPresentationStyle = .fullScreen
        self.viewcontroller?.present(vc, animated: true)
      }
    }
  }
  
}
