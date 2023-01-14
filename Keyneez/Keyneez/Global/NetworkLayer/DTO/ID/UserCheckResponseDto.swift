//
//  UserCheckResponseDto.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

struct UserCheckResponseDto: Codable {
  let userKey,
      userAge,
      userCharacter: Int
  let userName,
      userGender,
      userPhone,
      userBirth,
      userSchool,
      userPassword,
      userOcr: String
  let ocrDir: Bool
  let characters: [UserCheckCharacterData]
}

struct UserCheckCharacterData: Codable {
  let character: String
}

