//
//  ProductDanalResponseDto.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/11.
//

import Foundation

struct ProductDanalResponseDto: Codable {
  let status: String
  let message: String
  let productDanalData: ProductDanalData?
}

struct ProductDanalData: Codable {
  let userName: String
  let userPhone: String
  let accessToken: String
}

