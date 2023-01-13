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
  var accessToken: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2tleSI6Mjc1LCJpYXQiOjE2NzM2MjcyNjQsImV4cCI6MTY3MzYzNDQ2NH0.BQ1kUEycoo7tfP5kmiQcETR6CtS3wpiqxeaqZDSfO-E"

}
