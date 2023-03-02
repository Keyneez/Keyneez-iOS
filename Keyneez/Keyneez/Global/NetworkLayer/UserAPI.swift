//
//  APITarget.swift
//  Keyneez
//
//  Created by Jung peter on 1/11/23.
//

import Foundation

enum UserAPIError: LocalizedError {
  case encodingError
}

enum UserAPI {
  case postUserInfo(param: ProductDanalRequestDto)
  case patchUserPickInfo(token: String, param: ProductJellyRequstDto)
  case patchUserPwdInfo(token: String, param: ProductPwdRequestDto)
  case postPwdFetch(token: String, param: PasswordFetchRequestDto)
  case postUserLoginInfo(param: LoginRequestDto)
  case getUserInfo(token: String)
  case patchUserWithOCRSchoolID(token: String, param: UserCheckStudentIDRequestDto)
  case patchUserWithOCRTeenID(token: String, param: UserCheckYouthIDRequestDto)
}

extension UserAPI {
  
  var baseURL: URL {
    return URL(string: "http://15.165.186.200:3000")!
  }
  
  var path: String {
    switch self {
    case .getUserInfo:
      return URLConstant.user
    case .postUserInfo,
        .patchUserPickInfo:
      return "/user/signup"
    case .patchUserPwdInfo,
        .postPwdFetch:
      return "/user/signup/pw"
    case .postUserLoginInfo:
      return "/user/signin"
    case .patchUserWithOCRSchoolID,
        .patchUserWithOCRTeenID,
        .getUserInfo:
      return "/user"
    default:
      return ""
    }
  }
  
  var method: String {
    switch self {
    case .postUserInfo:
      return "POST"
    case .patchUserPickInfo,
        .patchUserPwdInfo,
        .patchUserWithOCRTeenID,
        .patchUserWithOCRSchoolID:
      return "PATCH"
    case .postPwdFetch,
        .postUserLoginInfo:
      return "POST"
    case .getUserInfo:
      return "GET"
    }
  }
  
  var headers: [String: String]? {
    switch self {
    case .postUserInfo,
        .postUserLoginInfo:
      return ["Content-Type": "application/json"]
    case .patchUserPickInfo(let token, _),
        .patchUserPwdInfo(let token, _),
        .postPwdFetch(let token, _),
        .getUserInfo(let token),
        .patchUserWithOCRTeenID(let token, _),
        .patchUserWithOCRSchoolID(let token, _):
      return ["Content-Type": "application/json", "Authorization": token]
    default:
      return nil
    }
  }
  
  private func body() -> [String: Any]? {
    switch self {
    case .postUserInfo(let param):
      return try? param.asParameter()
    case .patchUserPickInfo(_, let param):
      return try? param.asParameter()
    case .patchUserPwdInfo(_, param: let param):
      return try? param.asParameter()
    case .postPwdFetch(_, param: let param):
      return try? param.asParameter()
    case .postUserLoginInfo(param: let param):
      return try? param.asParameter()
    case .patchUserWithOCRSchoolID(_, param: let param):
      return try? param.asParameter()
    case .patchUserWithOCRTeenID(token: let token, param: let param):
      return try? param.asParameter()
    case .getUserInfo:
      return nil
    }
  }
  
// Url Request setting 함수
  func asURLRequest() -> URLRequest {
    let url = baseURL.appendingPathComponent(path)
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.allHTTPHeaderFields = headers
    
    if let param = body() {
      let jsonData = try? JSONSerialization.data(withJSONObject: param)
      request.httpBody = jsonData
    }
    return request
  }
}
