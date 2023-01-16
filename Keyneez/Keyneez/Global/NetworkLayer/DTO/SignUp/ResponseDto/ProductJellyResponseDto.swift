//
//  ProductJellyResponseDto.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/11.
//

import Foundation

// MARK: - 유저 생성 (성향, 관심사) ResponseDto

struct ProductJellyResponseDto: Codable {
  let userKey: Int
  let userName: String
  let userAge: Int?
  let userGender: String
  let userPhone: String
  let userBirth: String
  let userSchool: String?
  let userCharacter: Int
  let userPassword: String?
  let userOcr: String?
  let ocrDir: Bool
  let userBenefit: Bool
  let Characters: Characters?
}

struct Characters: Codable {
  let characterKey: Int
  let inter: String
  let dispo: String
  let character: String
  let characterImg: String
  let characterDesc: String
  let testImg: String
  let Items: [Items]
}

struct Items: Codable {
  let itemsKey: Int
  let itemImg: String
  let itemName: String
}
