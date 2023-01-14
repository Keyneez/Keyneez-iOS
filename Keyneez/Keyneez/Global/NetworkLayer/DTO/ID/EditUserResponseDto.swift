//
//  EditUserResponseDto.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

struct EditUserResponseDto: Codable {
  let userName: String
  let userSchool, userBirth, userOcr: String?
  let ocrDir: Bool
}
