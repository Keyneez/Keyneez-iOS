//
//  HomeContentResponseDto.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

struct HomeContentResponseDto: Codable {
  let status: Int
  let message: String
  let data: [HomeContentResponseData]
}

struct HomeContentResponseData: Codable {
  let contentKey: Int
  let contentTitle,
      contentImg,
      introduction,
      usage,
      startAt,
      endAt: String
  let liked: Bool
  let category: [String]
}
