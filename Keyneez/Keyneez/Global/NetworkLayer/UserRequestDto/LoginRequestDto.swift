//
//  LoginRequestDto.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/11.
//

import Foundation

// MARK: - 유저 로그인 RequestDto

struct LoginRequestDto: Codable {
  let userPhone: String
  let userPassword: String
}
