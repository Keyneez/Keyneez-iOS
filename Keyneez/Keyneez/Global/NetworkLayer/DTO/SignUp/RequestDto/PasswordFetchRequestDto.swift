//
//  PasswordFetchRequestDto.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/11.
//

import Foundation

// MARK: - 비밀번호 대조 ReqeustDto

struct PasswordFetchRequestDto: Codable {
  let userPassword: String
}
