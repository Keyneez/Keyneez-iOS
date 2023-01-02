//
//  Buildable.swift
//  Keyneez
//
//  Created by 최효원 on 2023/01/02.
//

import UIKit

protocol Buildable {
    associatedtype ViewType
    func build(_ config: ((ViewType) -> Void)?) -> ViewType
}
