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
  var userCharacter: String?
  var userPhoneNumber: String
}

struct UserCharacters {
  let characterKey: Int
  let inter, dispo, character, characterImg, characterDesc, testImg: String
}

final class UserSession {
  
  static let shared = UserSession()
  private init() { }
  
  var profile: Profile?
  var characters: UserCharacters?
  var accessToken: String? = ""

}
