//
//  ProductDanalRequestDto.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/11.
//

import Foundation

// MARK: - 유저 생성(다날) RequestDto

struct ProductDanalRequestDto: Codable {
  let userName: String
  let userBirth: String
  let userGender: String
  let userPhone: String
  
}
