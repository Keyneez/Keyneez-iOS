//
//  ProductJellyRequestDto.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/11.
//

import Foundation

//MARK: - 유저 생성(성향, 관심사) RequestDto

struct ProductJellyRequstDto: Codable {
  let dispositon: String
  let interst: [String]
}
