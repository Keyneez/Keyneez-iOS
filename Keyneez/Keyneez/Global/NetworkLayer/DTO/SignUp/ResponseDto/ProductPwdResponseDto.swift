//
//  UserProductResponseDto.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/11.
//

import Foundation

// MARK: - 유저 생성(비밀번호) ResponseDto

struct ProductPwdResponseDto: Codable {
  let status: Int
  let message: String
  let productPwdData: ProductPwdData?
}

struct ProductPwdData: Codable {
  let userName: String
  let userPhone: String
  let userPassword: String
}
