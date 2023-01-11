//
//  EditUserResponseDto.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

struct EditUserResponseDto: Codable {
  let status: Int
  let message: String
  let data: [EditUserResponseData]
}

struct EditUserResponseData: Codable {
  let userName,
      userSchool,
      userBirth,
      userOcr: String
  let ocrDir: Bool
}
