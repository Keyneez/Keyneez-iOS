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
  
  func postUserInfo(param: ProductDanalRequestDto, completion: @escaping (Result<ProductDanalResponseDto?, Error>) -> Void) {
    let target = UserAPI.postUserInfo(param: param)
    responseFrom(target, modelType: ProductDanalResponseDto.self, completion: completion)
  }
  
  func patchUserInfo(token: String, param: ProductJellyRequstDto, completion: @escaping (Result<ProductJellyResponseDto?, Error>) -> Void) {
    let target = UserAPI.patchUserPickInfo(token: token, param: param)
    responseFrom(target, modelType: ProductJellyResponseDto.self, completion: completion)
  }
  
  func patchPwdInfo(token: String, param: ProductPwdRequestDto, completion: @escaping (Result<ProductPwdResponseDto?, Error>) -> Void) {
    let target = UserAPI.patchUserPwdInfo(token: token, param: param)
    responseFrom(target, modelType: ProductPwdResponseDto.self, completion: completion)
  }
  
  func postLoginInfo(param: LoginRequestDto, completion: @escaping (Result<LoginResponseDto?, Error>) -> Void) {
    let target = UserAPI.postUserLoginInfo(param: param)
    responseFrom(target, modelType: LoginResponseDto.self, completion: completion)
  }
  
  func getUserInfo(token: String, completion: @escaping (Result<UserInquiryResponseDto?, Error>) -> Void) {
    let target = UserAPI.getUserInfo(token: token)
    responseFrom(target, modelType: UserInquiryResponseDto.self, completion)
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
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      if let data = try? decoder.decode(GenericResponse<T>.self, from: response.data), data.status >= 200 && data.status < 400 {
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
