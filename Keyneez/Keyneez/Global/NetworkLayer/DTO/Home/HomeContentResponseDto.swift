//
//  HomeContentResponseDto.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

//struct HomeContentResponseDto: Codable {
//  let status: Int
//  let message: String
//  let data: [HomeContentResponseData]
//}

struct HomeContentResponseDto: Codable {
  let contentKey: Int
  let contentTitle,
      contentImg,
      introduction,
      usage: String
  let startAt, endAt: String?
  let liked: Bool
  let category: [String]
}
