//
//  SearchContentResponseDto.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

struct SearchContentResponseDto: Codable {
  let contentKey: Int
  let contentTitle: String
  let startAt,
      endAt,
      contentImg: String?
  let liked: Bool
}
