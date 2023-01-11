//
//  APITarget.swift
//  Keyneez
//
//  Created by Jung peter on 1/11/23.
//

import Foundation
import Moya

enum UserAPI {
  case postUserInfo(token: String, name: String, userBirth: String, userGender: String, userPhone: String)
  case postUserCategory(token: String, disposition: String, interest: [String])
}

extension UserAPI: TargetType {
  
}
