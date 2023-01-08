//
//  HomeSearchModel.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/09.
//

import Foundation

struct HomeSearchModel {
  let contentTitle: String
  let startAt: String
  let endAt: String
  let isLiked: Bool
}

var homeSearchList: [HomeSearchModel] = [
  HomeSearchModel(contentTitle: "청소년 미술관 할인", startAt: "", endAt: "", isLiked: false),
  HomeSearchModel(contentTitle: "여행? 바로 가자", startAt: "20221124", endAt: "20221231", isLiked: true),
  HomeSearchModel(contentTitle: "청소년 영화관 할인", startAt: "20221124", endAt: "20221231", isLiked: true),
  HomeSearchModel(contentTitle: "청소년 영화관 할인", startAt: "", endAt: "", isLiked: false),
  HomeSearchModel(contentTitle: "청소년 영화관 할인", startAt: "", endAt: "", isLiked: false),
  HomeSearchModel(contentTitle: "농촌 봉사활동", startAt: "20221124", endAt: "20221231", isLiked: true)
]
