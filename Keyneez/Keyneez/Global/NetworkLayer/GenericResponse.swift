//
//  GenericResponse.swift
//  Keyneez
//
//  Created by Jung peter on 1/11/23.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
  
  var status: Int
  var message: String
  var data: T?
  
  enum CodingKeys: String, CodingKey {
    case status
    case message
    case data
  }

  // TODO: throws 애러다 뿜어야할듯
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.status = (try? container.decode(Int.self, forKey: .status.self)) ?? 500
    self.message = (try? container.decode(String.self, forKey: .message.self)) ?? ""
    self.data = (try? container.decode(T.self, forKey: .data.self))
  }
}
