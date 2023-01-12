//
//  UserProvier.swift
//  Keyneez
//
//  Created by Jung peter on 1/11/23.
//

import Moya
import Foundation

enum DecodeError: Error {
  case decodeError
}

struct UserInfo: Codable {
  var userName: String
  var userPhone: String
  var accessToken: String
}

final class UserAPIProvider {
  
  static let shared: UserAPIProvider = .init()
  let userProvider = MoyaProvider<UserAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
  
  private init() { }
  
  func postUserInfo(param: UserCheckResponseDto, completion: @escaping (Result<UserInfo?, Error>) -> Void) {
    let target = UserAPI.postUserInfo(param: param)
    responseFrom(target, modelType: UserInfo.self, completion: completion)
  }
  
}

extension UserAPIProvider {
  
  func responseFrom<T: Codable>(_ target: UserAPI, modelType: T.Type, completion: @escaping (Result<T?, Error>) -> Void) {
    userProvider.request(target) { result in
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
        let body = data.data
        completion(.success(body as? T))
      } else {
        completion(.failure(DecodeError.decodeError))
      }
    case .failure(let error):
      completion(.failure(error))
    }
  }
}
