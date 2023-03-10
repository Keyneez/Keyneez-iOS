//
//  ContentRepository.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/12.
//

import Foundation

protocol ContentRepository {
  func getAllContents(token: String, completion: @escaping([HomeContentResponseDto]) -> Void)
  func getDetailContent(token: String, contentId: Int, completion: @escaping(ContentDetailResponseDto) -> Void)
  func getSearchContent(token: String, keyword: String, completion: @escaping([SearchContentResponseDto]) -> Void)
  func getLikedContent(token: String, completion: @escaping([MyLikedContentResponseDto]) -> Void)
  func postLikeContent(token: String, contentId: Int, completion: @escaping(LikeContentRequestDto) -> Void)
}

final class KeyneezContentRepository: ContentRepository {
  func getAllContents(token: String, completion: @escaping ([HomeContentResponseDto]) -> Void) {
    print(token)
    ContentAPIProvider.shared.getAllContent(token: token) { result in
      switch result {
      case .success(let data):
        guard let contentlist = data else { return }
        completion(contentlist)
      case .failure(let failure):
        print("fail")
      }
    }
  }
  
  func getDetailContent(token: String, contentId: Int, completion: @escaping(ContentDetailResponseDto) -> Void) {
    ContentAPIProvider.shared.getDetailContent(token: token, contentId: contentId) { result in
      switch result {
      case .success(let data):
        guard let detailContentList = data else { return }
        completion(detailContentList)
      case .failure(let failure):
        print("fail")
      }
    }
  }
  
  func getSearchContent(token: String, keyword: String, completion: @escaping ([SearchContentResponseDto]) -> Void) {
    ContentAPIProvider.shared.getSearchContent(token: token, keyword: keyword) { result in
      switch result {
      case .success(let data):
        guard let searchList = data else { return }
        completion(searchList)
      case .failure(let failure):
        print("fail")
      }
    }
  }
  
  func getLikedContent(token: String, completion: @escaping ([MyLikedContentResponseDto]) -> Void) {
    ContentAPIProvider.shared.getLikedContent(token: token) { result in
      switch result {
      case .success(let data):
        guard let likedContentList = data else { return }
        completion(likedContentList)
      case .failure(let failure):
        print("fail")
      }
    }
  }
  
  func postLikeContent(token: String, contentId: Int, completion: @escaping (LikeContentRequestDto) -> Void) {
    ContentAPIProvider.shared.postLikeContent(token: token, contentId: contentId) { result in
      switch result {
      case .success(let data):
        guard let postLikeContentData = data else { return }
        completion(postLikeContentData)
      case .failure(let failuer):
        print("fail")
      }
    }
  }
}
