//
//  ContentAPI.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/12.
//

import Foundation
import Moya

enum ContentAPI {
  case getAllContents(token: String)
  case getDetailContent(param: ContentDetailResponseDto)
  case getSearchContent(token: String, keyword: String)
  case postLikeContent
  case getLikedContent
}

extension ContentAPI: TargetType {
  var baseURL: URL {
    return URL(string: URLConstant.baseURL)!
  }
  
  var path: String {
    switch self {
    case .getAllContents:
      return URLConstant.content
    case .getDetailContent:
      return URLConstant.contentDetail
    case .getSearchContent:
      return URLConstant.searchContent
    case .postLikeContent:
      return URLConstant.likeContent
    case .getLikedContent:
      return URLConstant.saveContent
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getAllContents,
        .getDetailContent,
        .getSearchContent,
        .getLikedContent:
      return .get
    case .postLikeContent:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .getAllContents:
      return .requestPlain
    case .getDetailContent(let param):
      return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
    case .getSearchContent(_, let keyword):
      return .requestParameters(parameters: ["keyword": keyword], encoding: URLEncoding.queryString)
    case .postLikeContent:
      return .requestPlain
    case .getLikedContent:
      return .requestPlain
    }
  }
  
  var headers: [String: String]? {
    switch self {
    case .getDetailContent:
      return ["Content-Type": "application/json"]
    case .getAllContents(let token), .getSearchContent(let token, _):
      return ["Content-Type": "application/json", "Authorization": token]
    default:
      return nil
    }
  }
}
