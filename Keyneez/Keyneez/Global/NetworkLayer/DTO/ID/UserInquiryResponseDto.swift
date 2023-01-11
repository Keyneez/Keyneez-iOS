//
//  UserInquiryResponseDto.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

struct UserInquiryResponseDto: Codable {
  let status: Int
  let message: String
  let data: [UserInquiryResponseData]
}

struct UserInquiryResponseData: Codable {
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
  let characters: [UserInquiryCharacterData]
}

struct UserInquiryCharacterData: Codable {
  let character: String
}
