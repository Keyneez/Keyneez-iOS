//
//  ContentDetailResponseDto.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

struct ContentDetailResponseDto: Codable {
  let contentKey: Int
  let contentTitle,
      place,
      introduction,
      benefit,
      usage: String
  let contentImg,
      startAt,
      endAt: String?
  let contentLink: URL
  let liked: Bool
  let category: [String]
}
