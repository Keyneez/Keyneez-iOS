//
//  LoginRequestDto.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/13.
//

import Foundation

//MARK: - 로그인 Request Dto

struct LoginRequestDto: Codable {
  let userPhone: String
  let userPassword: String
}
