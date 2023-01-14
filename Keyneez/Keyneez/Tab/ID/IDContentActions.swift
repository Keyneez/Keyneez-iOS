//
//  IDContentActions.swift
//  Keyneez
//
//  Created by Jung peter on 1/6/23.
//

import UIKit

final class IDContentActions: IDCardContentActionables, IDNotAvailableActionables {
  
  private weak var viewController: NiblessViewController?
  private let idRepository: IDRepository = KeyneezIDRepository()
  
  func touchIssueIDcard(to target: NiblessViewController) -> UIAction {
    return UIAction(handler: { [weak self] _ in
      target.modalPresentationStyle = .fullScreen
      self?.viewController?.present(target, animated: true)
    })
  }
  
  init(viewcontroller: NiblessViewController) {
    self.viewController = viewcontroller
  }
  
  func touchDetailInfo(to target: BottomSheetViewController) -> UIAction {
    return UIAction(handler: { _ in
      guard let vc = self.viewController else {return}
      vc.present(target, animated: true)
    })
  }
  
  func touchBenefitInfo(to target: BottomSheetViewController) -> UIAction {
    return UIAction(handler: { _ in
      guard let vc = self.viewController else {return}
      vc.present(target, animated: true)
    })
  }
  
  func touchRealIDCardAuth(to target: NiblessViewController) -> UIAction {
    return UIAction(handler: { _ in
      guard let vc = self.viewController else {return}
      target.modalPresentationStyle = .fullScreen
      vc.present(target, animated: true)
    })
  }
  
//  func getUserInfo() -> UIAction {
//    return UIAction(handler: { _ in
//      guard let token = UserSession.shared.accessToken else { return }
//      idRepository.getUserInfo(token: token) {
//        [weak self] userInfo in
//        guard let self else { return }
////        userInfo..
//      }
//      
//    })
//  }
  
}
