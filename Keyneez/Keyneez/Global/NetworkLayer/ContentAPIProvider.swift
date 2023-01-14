//
//  ContentAPIProvider.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/12.
//

import Foundation
import Moya

final class ContentAPIProvider {
  static let shared: ContentAPIProvider = .init()
  let contentProvider = MoyaProvider<ContentAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
  func getAllContent(token: String, completion: @escaping (Result<[HomeContentResponseDto]?, Error>) -> Void) {
    let target = ContentAPI.getAllContents(token: token)
    requestFrom(target, modelType: [HomeContentResponseDto].self, completion: completion)
  }
  func getSearchContent(token: String, keyword: String, completion: @escaping (Result<[SearchContentResponseDto]?, Error>) -> Void) {
    let target = ContentAPI.getSearchContent(token: token, keyword: keyword)
    requestFrom(target, modelType: [SearchContentResponseDto].self, completion: completion)
  }
  func getDetailContent(token: String, contentId: Int, completion: @escaping (Result<ContentDetailResponseDto?, Error>) -> Void) {
    let target = ContentAPI.getDetailContent(token: token, contentId: contentId)
    requestFrom(target, modelType: ContentDetailResponseDto.self, completion: completion)
  }
  func getLikedContent(token: String, completion: @escaping (Result<[MyLikedContentResponseDto]?, Error>) -> Void) {
    let target = ContentAPI.getLikedContent(token: token)
    requestFrom(target, modelType: [MyLikedContentResponseDto].self, completion: completion)
  }
  func postLikeContent(token: String, contentId: Int, completion: @escaping (Result<LikeContentRequestDto?, Error>) -> Void) {
    let target = ContentAPI.postLikeContent(token: token, contentId: contentId)
    requestFrom(target, modelType: LikeContentRequestDto.self, completion: completion)
  }
  
}

extension ContentAPIProvider {
  func requestFrom<T: Codable>(_ target: ContentAPI, modelType: T.Type, completion: @escaping (Result<T?, Error>) -> Void) {
    contentProvider.request(target) { result in
      
      self.process(type: modelType, result: result, completion: completion)
    }
  }
  
  func process<T: Codable>(
    type: T.Type,
    result: Result<Response, MoyaError>,
    completion: @escaping (Result<T?, Error>) -> Void
  ) {
    switch result {
    case .success(let response):
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      if let data = try? decoder.decode(GenericResponse<T>.self, from: response.data) {
        guard let body = data.data else { print("ContentAPI nobddy"); return }
        completion(.success(body))
      } else {
        completion(.failure(DecodeError.decodeError))
      }
    case .failure(let error):
      completion(.failure(error))
    }
  }
}
