//
//  UserProvier.swift
//  Keyneez
//
//  Created by Jung peter on 1/11/23.
//

import Foundation

struct UserInfo {
  var userName
}

final class UserAPIProvider {
  
  static let shared: UserAPIProvider = .init()
  
  private init() { }
  
  func postUserInfo() async throws ->
  
}
