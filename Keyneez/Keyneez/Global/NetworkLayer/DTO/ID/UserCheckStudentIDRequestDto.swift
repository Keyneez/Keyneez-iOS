//
//  UserCheckStudentIDRequestDto.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

struct UserCheckStudentIDRequestDto: Codable {
  let userSchool,
      userName,
      userOcr: String
  let ocrDir: Bool
}
