//
//  HomeRepository.swift
//  Keyneez
//
//  Created by Jung peter on 1/11/23.
//

import Foundation

protocol ContentRepository {
  
  func getAllHomeContent(token: String, completion: @escaping([HomeContentResponseDto]) -> Void)
  func getDeetailContent(token: String, contentID: Int) -> HomeContentResponseDto?
  func searchContent(token: String, keyword: String) -> SearchContentResponseDto?
  
}

final class KeyneezContentRepository: ContentRepository {
  func getAllHomeContent(token: String, completion: @escaping ([HomeContentResponseDto]) -> Void) {
    //비동기처리
    UserAPIProvider.shared.postUserInfo(param: param) { result in
      switch result {
      case .success(let data):
        completion(data)
      case .failure(let failure):
        <#code#>
      }
    }
  }
  
  func getDeetailContent(token: String, contentID: Int) -> HomeContentResponseDto? {
    return nil
  }
  
  func searchContent(token: String, keyword: String) -> SearchContentResponseDto? {
    return nil
  }
  
  
}
