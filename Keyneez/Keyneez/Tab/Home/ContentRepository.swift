//
//  ContentRepository.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/12.
//

import Foundation

protocol ContentRepository {
  func getAllContents(token: String)
  func getDetailContent(token: String, contentID: Int)
  func getSearchContent(token: String, keyword: String)
}

final class KeyneezContentRepository: ContentRepository {
  func getAllContents(token: String) {
  }
  
  func getDetailContent(token: String, contentID: Int) {
    <#code#>
  }
  
  func getSearchContent(token: String, keyword: String) {
    <#code#>
  }
}
