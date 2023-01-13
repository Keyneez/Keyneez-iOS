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
  var accessToken: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2tleSI6Mjc3LCJpYXQiOjE2NzM2MzU3ODIsImV4cCI6MTY3MzY0Mjk4Mn0.XlA3A1w72I3OIF3h_nBxk4WtDjl_-gDV97xzw_fllCQ"

}
