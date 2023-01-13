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
  PropensityTagContentModel(text: "activeUnClick"),
  PropensityTagContentModel(text: "curiousUnclick"),
  PropensityTagContentModel(text: "comportableUnclick")
]

var propensityTagClickData: [PropensityTagContentModel] = [
  PropensityTagContentModel(text: "activeClick"),
  PropensityTagContentModel(text: "curiousClick"),
  PropensityTagContentModel(text: "comportableClick")
]

struct HashTagContentModel {
  let image: String
  let text: String
}

var hashTagData: [HashTagContentModel] = [
  HashTagContentModel(image: "amusementPark", text: "놀이공원"),
  HashTagContentModel(image: "active", text: "대외활동"),
  HashTagContentModel(image: "traffic", text: "대중교통"),
  HashTagContentModel(image: "movie", text: "영화관"),
  HashTagContentModel(image: "add", text: "혜택"),
  HashTagContentModel(image: "travel", text: "여행"),
  HashTagContentModel(image: "scholaship", text: "장학"),
  HashTagContentModel(image: "art", text: "미술관"),
  HashTagContentModel(image: "checkCard", text: "체크카드"),
  HashTagContentModel(image: "volunteer", text: "봉사"),
  HashTagContentModel(image: "museum", text: "박물관"),
  HashTagContentModel(image: "career", text: "진로")
]

struct JellyContentModel {
  let itemImage: String
  let backImage: String
}

var jellyIconData: [JellyContentModel] = [
  JellyContentModel(itemImage: "skateboard", backImage: "jellybackground_line" ),
  JellyContentModel(itemImage: "headset", backImage: "jellybackground_line"),
  JellyContentModel(itemImage: "hat", backImage: "jellybackground"),
  JellyContentModel(itemImage: "glasses", backImage: "jellybackground"),
  JellyContentModel(itemImage: "book", backImage: "jellybackground"),
  JellyContentModel(itemImage: "wing", backImage: "jellybackground"),
  JellyContentModel(itemImage: "ring", backImage: "jellybackground"),
  JellyContentModel(itemImage: "telescope", backImage: "jellybackground"),
  JellyContentModel(itemImage: "coin", backImage: "jellybackground"),
  JellyContentModel(itemImage: "tie", backImage: "jellybackground")
]

struct SimplePwdContentModel {
  let text: String
}

var pwdNumberData: [SimplePwdContentModel] = [
  SimplePwdContentModel(text: "8"),
  SimplePwdContentModel(text: "9"),
  SimplePwdContentModel(text: "7"),
  SimplePwdContentModel(text: "0"),
  SimplePwdContentModel(text: "3"),
  SimplePwdContentModel(text: "6"),
  SimplePwdContentModel(text: "5"),
  SimplePwdContentModel(text: "2"),
  SimplePwdContentModel(text: "4"),
  SimplePwdContentModel(text: "재배열"),
  SimplePwdContentModel(text: "1"),
  SimplePwdContentModel(text: "  ")
]
