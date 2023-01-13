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
  var accessToken: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2tleSI6MzEyLCJpYXQiOjE2NzM2NDExOTUsImV4cCI6MTY3MzY0ODM5NX0.thu5Mu3sVDYgC_lnKDbXthIo0z4ubl-Col67OTm4Eh8"

}
