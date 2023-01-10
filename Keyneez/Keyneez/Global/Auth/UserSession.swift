//
//  UserSession.swift
//  Keyneez
//
//  Created by Jung peter on 1/11/23.
//

import Foundation

final class UserSession {
  
  static let shared = UserSession()
  private init() { }
  
  var name: String?
  var userPhone: String?
  var accessToken: String?

}
