//
//  APITarget.swift
//  Keyneez
//
//  Created by Jung peter on 1/11/23.
//

import Foundation
import Moya

enum UserAPIError: LocalizedError {
  case encodingError
}

enum UserAPI {
  case postUserInfo(param: ProductDanalRequestDto)
  case postUserPickInfo(param: ProductJellyRequstDto)
  case patchUserPwdInfo(param: ProductPwdRequestDto)
  case postPwdFetch(param: PasswordFetchRequestDto)
  case postUserLoginInfo(param: LoginRequestDto)
}

extension UserAPI: TargetType {
  
  var baseURL: URL {
    return URL(string: "http://15.165.186.200:3000")!
  }
  
  var path: String {
    switch self {
    case .postUserInfo, .postUserPickInfo :
      return "/user/signup"
    case .patchUserPwdInfo, .postPwdFetch :
      return "/user/signup/pw"
    case .postUserLoginInfo :
      return "/user/signin"
    default:
      return ""
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .postUserInfo:
      return .post
    case .postUserPickInfo:
      return .post
    case .patchUserPwdInfo:
      return .patch
    case .postPwdFetch:
      return .post
    case .postUserLoginInfo:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .postUserInfo(let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .postUserPickInfo(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .patchUserPwdInfo(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .postPwdFetch(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .postUserLoginInfo(param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    }
  }
  
  var headers: [String: String]? {
    switch self {
    case .postUserInfo:
      return ["Content-Type": "application/json"]
    default:
      return nil
    }
  }
  
}
