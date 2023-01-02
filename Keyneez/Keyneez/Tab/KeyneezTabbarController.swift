//
//  KeyneezTabbarController.swift
//  Keyneez
//
//  Created by Jung peter on 12/26/22.
//

import UIKit
import Then

private class TabInfoClass {
  var viewController: UIViewController.Type?
  var title: String = ""
  var imageName: String = ""
  
  init(viewController: UIViewController.Type, title: String, imageName: String) {
    self.viewController = viewController
    self.title = title
    self.imageName = imageName
  }
}

final class KeyneezTabbarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    assignTabbar()
    createTabbarItems()
  }

  private func assignTabbar() {
    let tabBar = { () -> KeyneezTabar in
      let tabBar = KeyneezTabar().then {
        $0.delegate = self
        $0.unselectedItemTintColor = .gray400
        $0.tintColor = .gray900
      }
      return tabBar
    }()
    self.setValue(tabBar, forKey: "tabBar")
  }
}

// MARK: - Setting ViewController in TabbarViewController
extension KeyneezTabbarController {
  fileprivate func createTabbarItems() {
    let viewControllers = [HomeViewController.self, LikeViewController.self, IDViewController.self,
      MyPageViewController.self, SettingViewController.self]
    let titles = ["홈", "좋아요", "", "캐릭터", "설정"]
    let imageNames = [
      "ic_home_tabbar", "ic_like_tabbar", "id_card_tabbar", "ic_jelly_tabbar", "ic_more_tabbar"]
    var tabInfos: [TabInfoClass] = []
    for i in 0...4 {
      tabInfos.append(TabInfoClass(viewController: viewControllers[i],
                                         title: titles[i], imageName: imageNames[i]))}
    let navigations = tabInfos.map{
      makeViewController(viewController: $0.viewController!, title: $0.title,
                         imageName: $0.imageName) }
    self.viewControllers = navigations
  }

  private func makeViewController(viewController: UIViewController.Type, title: String,
                                  imageName: String) -> UINavigationController {
    let viewController = viewController.init()
    let nav = UINavigationController(rootViewController: viewController)
    nav.tabBarItem = (imageName == "id_card_tabbar") ?
    UITabBarItem(title: title, image:
                  UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal),
                 selectedImage: nil) :
    UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: nil)
    return nav
  }
}
