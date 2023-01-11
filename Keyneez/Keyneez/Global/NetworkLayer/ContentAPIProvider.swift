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
  func getAllContent() {
    let target = ContentAPI.getAllContents
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
      if let data = try? JSONDecoder().decode(GenericResponse<T>.self, from: response.data) {
        completion(.success(data as? T))
      } else {
        completion(.failure(DecodeError.decodeError))
      }
    case .failure(let error):
      completion(.failure(error))
    }
  }
}
