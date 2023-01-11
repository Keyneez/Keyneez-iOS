//
//  UserCheckYouthIDRequestDto.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

struct UserCheckYouthIDRequestDto: Codable {
  let userName,
      userBirth,
      userOcr: String
  let ocrDir: Bool
}
