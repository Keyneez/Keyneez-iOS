//
//  SignUpContentModel.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/08.
//

import Foundation
import UIKit

struct PropensityTagContentModel {
  let text: String
}

var propensityTagUnclickData: [PropensityTagContentModel] = [
  PropensityTagContentModel(text: "활발하게 놀러다녀요!"),
  PropensityTagContentModel(text: "호기심 가득 정보를 탐색중"),
  PropensityTagContentModel(text: "포근한 집이 최고")
]

var propensityTagClickData: [PropensityTagContentModel] = [
  PropensityTagContentModel(text: "🎾 활발하게 놀러다녀요!"),
  PropensityTagContentModel(text: "🔍 호기심 가득 정보를 탐색중"),
  PropensityTagContentModel(text: "🧸 포근한 집이 최고")
]

struct HashTagContentModel {
  let image: String
  let text: String
}

var hashTagData: [HashTagContentModel] = [
  HashTagContentModel(image: "amusementPark", text: "#놀이공원"),
  HashTagContentModel(image: "active", text: "#대외활동"),
  HashTagContentModel(image: "traffic", text: "#대중교통"),
  HashTagContentModel(image: "movie", text: "#영화관"),
  HashTagContentModel(image: "add", text: "#혜택"),
  HashTagContentModel(image: "travel", text: "#여행"),
  HashTagContentModel(image: "scholaship", text: "#장학"),
  HashTagContentModel(image: "art", text: "#미술관"),
  HashTagContentModel(image: "checkCard", text: "#체크카드"),
  HashTagContentModel(image: "volunteer", text: "#봉사"),
  HashTagContentModel(image: "museum", text: "#박물관"),
  HashTagContentModel(image: "career", text: "#진로")
]
