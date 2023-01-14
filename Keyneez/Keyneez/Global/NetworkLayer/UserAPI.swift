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
  case patchUserPickInfo(token: String, param: ProductJellyRequstDto)
  case patchUserPwdInfo(token: String, param: ProductPwdRequestDto)
  case postPwdFetch(token: String, param: PasswordFetchRequestDto)
  case postUserLoginInfo(param: LoginRequestDto)
  case getUserInfo(token: String)
  case patchUserWithOCRSchoolID(token: String, param: UserCheckStudentIDRequestDto)
  case patchUserWithOCRTeenID(token: String, param: UserCheckYouthIDRequestDto)
}

extension UserAPI: TargetType {
  
  var baseURL: URL {
    return URL(string: "http://15.165.186.200:3000")!
  }
  
  var path: String {
    switch self {
    case .postUserInfo, .patchUserPickInfo:
      return "/user/signup"
    case .patchUserPwdInfo, .postPwdFetch:
      return "/user/signup/pw"
    case .postUserLoginInfo:
      return "/user/signin"
    case .patchUserWithOCRSchoolID, .patchUserWithOCRTeenID, .getUserInfo:
      return "/user"
    default:
      return ""
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .postUserInfo:
      return .post
    case .patchUserPickInfo:
      return .patch
    case .patchUserPwdInfo, .patchUserWithOCRTeenID, .patchUserWithOCRSchoolID:
      return .patch
    case .postPwdFetch:
      return .post
    case .postUserLoginInfo:
      return .post
    case .getUserInfo:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .postUserInfo(let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .patchUserPickInfo(_, let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .patchUserPwdInfo(_, let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .postPwdFetch(_, param: let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .postUserLoginInfo(let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .getUserInfo:
      return .requestPlain
    case .patchUserWithOCRSchoolID(_, let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .patchUserWithOCRTeenID(_, let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    }
  }
  
  private var vaildationType: Moya.ValidationType {
    return .successAndRedirectCodes
  }
  
  var headers: [String: String]? {
    switch self {
    case .postUserInfo, .postUserLoginInfo:
      return ["Content-Type": "application/json"]
    case .patchUserPickInfo(let token, _), .patchUserPwdInfo(let token, _),
        .postPwdFetch(let token, _), .getUserInfo(let token), .patchUserWithOCRTeenID(let token, _), .patchUserWithOCRSchoolID(let token, _):
      return ["Content-Type": "application/json", "Authorization": token]
    default:
      return nil
    }
  }
  
}
