//
//  ContentDetailResponseDto.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

struct ContentDetailResponseDto : Codable {
  let status: Int
  let message: String
  let data: [ContentDetailResponseData]
}

struct ContentDetailResponseData: Codable {
  let contentKey: Int
  let contentTitle,
      contentImg,
      place,
      introduction,
      benefit,
      usage,
      startAt,
      endAt: String
  let contentLink: URL
  let liked: Bool
  let category: [String]
}
