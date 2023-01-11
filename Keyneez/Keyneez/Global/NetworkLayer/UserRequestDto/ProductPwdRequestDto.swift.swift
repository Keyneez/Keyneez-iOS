//
//  UserProductRequestDto.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/11.
//

import Foundation

// MARK: - 유저 생성(비밀번호) Request Dto

struct ProductPwdRequestDto: Codable {
    let userPassword: String
}
