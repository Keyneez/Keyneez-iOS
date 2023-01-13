//
//  LoginResponseDto.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/11.
//

import Foundation

// MARK: - 유저 로그인 ResponseDto

struct LoginResponseDto: Codable {
  let status: Int
  let message: String
  let loginData: LoginData?
}

struct LoginData: Codable {
  let accessToken: String
}
