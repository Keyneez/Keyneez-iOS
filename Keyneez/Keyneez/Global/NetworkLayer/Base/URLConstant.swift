//
//  URLConstant.swift
//  Keyneez
//
//  Created by 박의서 on 2023/01/11.
//

import Foundation

struct URLConstant {
  // MARK: - baseURL
  
  static let baseURL = (Bundle.main.infoDictionary?["BASE_URL"] as! String).replacingOccurrences(of: " ", with: "")
  
  // MARK: - User
  
  static let user = "user/"
  static let userCheck = user + "check/"
  
  // MARK: - Sign In
  
  static let signIn = user + "signin/"
  
  // MARK: - Sign Up
  
  static let signUp = user + "signup/"
  static let passwd = signUp + "pw/"
  
  // MARK: - Content
  
  static let content = "content/"
  static let contentDetail = content + "view/"
  static let searchContent = content + "search/"
  static let saveContent = content + "save/"
  static let likeContent = content + "liked/"
}
