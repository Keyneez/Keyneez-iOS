//
//  EditUserRequestDto.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

struct EditUserRequestDto: Codable {
  let userName,
      userOcr: String
  let userSchool, userBirth: String?
  let ocrDir: Bool
}
