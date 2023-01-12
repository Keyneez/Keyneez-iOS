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
  var accessToken: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2tleSI6MTEyLCJpYXQiOjE2NzM1MzE3MTEsImV4cCI6MTY3MzUzODkxMX0.Lesp-mp8ZZtXO5OEGXmtHYuUNDngMylbWgX2JOws1a8"

}
