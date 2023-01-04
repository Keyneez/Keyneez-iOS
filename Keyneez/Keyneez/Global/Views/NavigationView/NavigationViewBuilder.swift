//
//  NavigationViewBuilder.swift
//  Keyneez
//
//  Created by Jung peter on 1/3/23.
//

import UIKit

final class NavigationViewBuilder: Buildable {
  
  typealias ViewType = UIView
  
  private var barViews: [NavigationItemView]
  
  init(barViews: [NavigationItemView]) {
    self.barViews = barViews
  }
  
  func build(_ config: ((UIView) -> Void)? = nil) -> UIView {
    var navView = makeNavigationView(barViews: barViews)
    if let config = config {
      navView = navView.then(config)
    }
    return navView
  }
  
  private func makeNavigationView(barViews: [NavigationItemView]) -> UIView {
    return NavigationBar(frame: CGRect(), items: barViews)
  }
  
}
