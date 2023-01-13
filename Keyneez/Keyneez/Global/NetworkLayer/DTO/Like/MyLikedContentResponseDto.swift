//
//  MyLikedContentResponseDto.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

struct MyLikedContentResponseDto: Codable {
  let contentKey: Int
  let contentTitle,
      startAt,
      endAt,
      contentImg: String
}
