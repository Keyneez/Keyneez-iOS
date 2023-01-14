//
//  IDRepository.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/14.
//

import Foundation

protocol IDRepository {
  func getUserInfo(token: String, completion: @escaping(UserInquiryResponseDto) -> Void)
}

final class KeyneezIDRepository: IDRepository {
  func getUserInfo(token: String, completion: @escaping (UserInquiryResponseDto) -> Void) {
    UserAPIProvider.shared.getUserInfo(token: token) { result in
      switch result {
      case .success(let data):
        guard let userInfo = data else { return }
        completion(userInfo)
      case .failure(let failure):
        print("fail")
      }
    }
  }
}
