//
//  UserSession.swift
//  Keyneez
//
//  Created by Jung peter on 1/11/23.
//

import Foundation

struct Profile {
  var name: String
  var birthday: String
  var userOCRLink: String?
  var userCharacter: String
  var userPhoneNumber: String
}

final class UserSession {
  
  static let shared = UserSession()
  private init() { }
  
  var profile: Profile?
  var accessToken: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2tleSI6MTQ0LCJpYXQiOjE2NzM1Mzc5MzgsImV4cCI6MTY3MzU0NTEzOH0.aprLdFYrRgo3umCwOtK8tBxagIDf_HoF1BU8na_dO6s"

}
