//
//  IDCardCotentActionables.swift
//  Keyneez
//
//  Created by Jung peter on 1/6/23.
//

import UIKit

protocol IDCardContentActionables {
  func touchBenefitInfo(to target: BottomSheetViewController) -> UIAction
  func touchRealIDCardAuth(to target: NiblessViewController) -> UIAction
  func touchDetailInfo(to target: BottomSheetViewController) -> UIAction
}


