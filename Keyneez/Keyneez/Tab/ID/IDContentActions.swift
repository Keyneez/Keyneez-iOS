//
//  IDContentActions.swift
//  Keyneez
//
//  Created by Jung peter on 1/6/23.
//

import UIKit

struct IDContentActions: IDCardContentActionables, IDIssueActionables {
  
  func touchDetailInfo() -> UIAction {
    return UIAction(handler: { _ in print(self)})
  }
  
  func touchIssueIDcard() -> UIAction {
    return UIAction(handler: { _ in print(self)})
  }
  
  func touchBenefitInfo() -> UIAction {
    return UIAction(handler: { _ in print(self)})
  }
  
  func touchRealIDCardAuth() -> UIAction {
    return UIAction(handler: { _ in print(self)})
  }
  
}
