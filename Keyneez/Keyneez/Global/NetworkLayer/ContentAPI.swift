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
  case getDetailContent(token: String, contentId: Int)
  case getSearchContent(token: String, keyword: String)
  case postLikeContent
  case getLikedContent(token: String)
}

extension ContentAPI: TargetType {
  var baseURL: URL {
    return URL(string: URLConstant.baseURL)!
  }
  
  var path: String {
    switch self {
    case .getAllContents:
      return URLConstant.content
    case .getDetailContent(_, let contentId):
      return URLConstant.contentDetail+"\(contentId)"
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
    case .getAllContents, .getDetailContent:
      return .requestPlain
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
    case .getAllContents(let token),
        .getSearchContent(let token, _),
        .getDetailContent(let token, _),
        .getLikedContent(let token):
      return ["Content-Type": "application/json", "Authorization": token]
    default:
      return nil
    }
  }
}
