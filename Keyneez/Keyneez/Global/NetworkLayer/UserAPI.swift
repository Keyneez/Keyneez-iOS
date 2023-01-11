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
}

extension UserAPI: TargetType {
  
  var baseURL: URL {
    return URL(string: "http://15.165.186.200:3000")!
  }
  
  var path: String {
    switch self {
    case .postUserInfo:
      return "/user/signup"
    default:
      return ""
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .postUserInfo:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .postUserInfo(let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .postUserInfo:
      return ["Content-Type": "application/json"]
    default:
      return nil
    }
  }
  
}
