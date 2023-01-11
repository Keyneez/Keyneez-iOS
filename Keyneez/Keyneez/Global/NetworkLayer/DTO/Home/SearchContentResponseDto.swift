//
//  SearchContentResponseDto.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

struct SearchContentResponseDto: Codable {
  let status: Int
  let message: String
  let data: [SearchContentResponseData]
}

struct SearchContentResponseData: Codable {
  let contentKey: Int
  let contentTitle,
      startAt,
      endAt,
      contentImg: String
  let liked: Bool
}
