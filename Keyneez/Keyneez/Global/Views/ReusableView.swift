//
//  ReusableView.swift
//  Keyneez
//
//  Created by Jung peter on 1/5/23.
//

import Foundation

import Foundation
import UIKit

// tableview, collectionview에 identifier 쓸때 파일이름과 동일하게
// 사용할때는 00Cell.identifier

protocol ReusableView: AnyObject {
  
}

extension ReusableView where Self: UIView {
  static var identifier: String {
    return String(describing: self)
  }
}

extension UICollectionViewCell: ReusableView {}
extension UITableViewCell: ReusableView {}

extension UICollectionView {
  
  func register<T: UICollectionViewCell>(_ cellClass: T.Type){
    let identifier = T.identifier
    self.register(T.self, forCellWithReuseIdentifier: identifier)
  }
  
}

extension UITableView {
  
  func register<T: UITableViewCell>(_ cellClass: T.Type){
    let identifier = T.identifier
    self.register(T.self, forCellReuseIdentifier: identifier)
  }
  
}
