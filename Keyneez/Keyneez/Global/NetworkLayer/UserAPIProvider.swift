//
//  UserProvier.swift
//  Keyneez
//
//  Created by Jung peter on 1/11/23.
//

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
  
  private init() { }
  
  func postUserInfo(param: ProductDanalRequestDto, completion: @escaping (Result<ProductDanalResponseDto?, Error>) -> Void) {
    makeRequest(UserAPI.postUserInfo(param: param), modelType: ProductDanalResponseDto.self, completion: completion)
  }
  
  func patchUserInfo(token: String, param: ProductJellyRequstDto, completion: @escaping (Result<ProductJellyResponseDto?, Error>) -> Void) {
    makeRequest(UserAPI.patchUserPickInfo(token: token, param: param), modelType: ProductJellyResponseDto.self, completion: completion)
  }
  
  func patchPwdInfo(token: String, param: ProductPwdRequestDto, completion: @escaping (Result<ProductPwdResponseDto?, Error>) -> Void) {
    makeRequest(UserAPI.patchUserPwdInfo(token: token, param: param), modelType: ProductPwdResponseDto.self, completion: completion)
  }
  
  func postLoginInfo(param: LoginRequestDto, completion: @escaping (Result<LoginResponseDto?, Error>) -> Void) {
    makeRequest(UserAPI.postUserLoginInfo(param: param), modelType: LoginResponseDto.self, completion: completion)
  }
  
  func patchInfoWithStudentIDOCR(token: String, param: UserCheckStudentIDRequestDto, completion: @escaping(Result<EditUserResponseDto?, Error>) -> Void) {
    makeRequest(UserAPI.patchUserWithOCRSchoolID(token: token, param: param), modelType: EditUserResponseDto.self, completion: completion)
  }
  
  func patchInfoWithTeenIDOCR(token: String, param: UserCheckYouthIDRequestDto, completion:  @escaping(Result<EditUserResponseDto?, Error>) -> Void) {
    makeRequest(UserAPI.patchUserWithOCRTeenID(token: token, param: param), modelType: EditUserResponseDto.self, completion: completion)
  }
  
  func getUserInfo(token: String, completion: @escaping (Result<UserInquiryResponseDto?, Error>) -> Void) {
    makeRequest(UserAPI.getUserInfo(token: token), modelType: UserInquiryResponseDto.self, completion: completion)
  }
}

extension UserAPIProvider {
    
    func makeRequest<T: Codable>(_ target: UserAPI, modelType: T.Type, completion: @escaping (Result<T?, Error>) -> Void) {
      //세션 생성
      let session = URLSession.shared
      //task 지정
      let task = session.dataTask(with: target.asURLRequest()) { data, response, error in
        
        //에러 처리 - Response
        if let error = error {
          completion(.failure(error))
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
          completion(.failure(NetworkError.invalidResponse as! Error))
          return
        }
        
        let statusCode = httpResponse.statusCode
        guard (200..<300).contains(statusCode) else {
          completion(.failure(NetworkError.invalidStatusCode(statusCode)))
          return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if let data = data, let response = try? decoder.decode(GenericResponse<T>.self, from: data) {
          let body = response.data
          completion(.success(body as? T))
        } else {
          completion(.failure(DecodeError.decodeError))
        }
      }
      
      task.resume()
    }
  }
