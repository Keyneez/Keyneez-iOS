//
//  HomeContentModel.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/06.
//

import Foundation

struct HomeContentModel {
  let contentImage: String
  let startAt: String
  let endAt: String
  let contentTitle: String
  let introduction: String
  let categoty: [String]
  let liked: Bool
}

var recommendContentList: [HomeContentModel] = [
  HomeContentModel(contentImage: "", startAt: "11.24", endAt: "12.31", contentTitle: "청소년 미술관 할인", introduction: "어쩌구저쩌구", categoty: ["문화"], liked: false),
  HomeContentModel(contentImage: "", startAt: "12.31", endAt: "01.01", contentTitle: "예시입니당", introduction: "어쩌구저쩌구", categoty: ["문화", "예술"], liked: true)]

var popularContentList: [HomeContentModel] = [
  HomeContentModel(contentImage: "", startAt: "11.24", endAt: "12.31", contentTitle: "인기뷰 이거 인기뷰", introduction: "이거 인기뷰", categoty: ["문화"], liked: false),
  HomeContentModel(contentImage: "", startAt: "12.31", endAt: "01.01", contentTitle: "예시입니당", introduction: "어쩌구저쩌구", categoty: ["문화", "예술"], liked: true)]

var newestContentList: [HomeContentModel] = [
  HomeContentModel(contentImage: "", startAt: "11.24", endAt: "12.31", contentTitle: "최신뷰 이거 최신뷰", introduction: "이거 최신뷰", categoty: ["문화"], liked: false),
  HomeContentModel(contentImage: "", startAt: "12.31", endAt: "01.01", contentTitle: "예시입니당", introduction: "어쩌구저쩌구", categoty: ["문화", "예술"], liked: true)]

var homeSearchList: [HomeContentModel] = [
  HomeContentModel(contentImage: "", startAt: "", endAt: "", contentTitle: "청소년 미술관 할인", introduction: "이거 최신뷰", categoty: ["문화"], liked: false), HomeContentModel(contentImage: "", startAt: "20221124", endAt: "20221231", contentTitle: "여행? 바로 가자", introduction: "어쩌구저쩌구", categoty: ["문화", "예술"], liked: true), HomeContentModel(contentImage: "", startAt: "20221124", endAt: "20221231", contentTitle: "청소년 영화관 할인", introduction: "어쩌구저쩌구", categoty: ["문화", "예술"], liked: true), HomeContentModel(contentImage: "", startAt: "", endAt: "", contentTitle: "청소년 영화관 할인", introduction: "어쩌구저쩌구", categoty: ["문화", "예술"], liked: false), HomeContentModel(contentImage: "", startAt: "", endAt: "", contentTitle: "청소년 영화관 할인", introduction: "어쩌구저쩌구", categoty: ["문화", "예술"], liked: false), HomeContentModel(contentImage: "", startAt: "20221124", endAt: "20221231", contentTitle: "농촌 봉사활동", introduction: "어쩌구저쩌구", categoty: ["문화", "예술"], liked: true)
]
