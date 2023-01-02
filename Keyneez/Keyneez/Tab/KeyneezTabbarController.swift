//
//  KeyneezTabbarController.swift
//  Keyneez
//
//  Created by Jung peter on 12/26/22.
//

import UIKit
import Then

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

//TODO: 여기 아래 코드 줄일수 있는데 바꿔서 해봐 -> 힌트는 map
//    let viewControllers = [HomeViewController.self, CameraViewController.self, ProfileViewController.self, ProfileViewController.self, ProfileViewController.self]
//    let titles = ["홈", "좋아요", "", "캐릭터", "설정"]
//    let imageNames = ["ic_home_tabbar", "ic_like_tabbar", "id_card_tabbar", "ic_jelly_tabbar", "ic_more_tabbar"]
//    let navigations = zip(viewControllers, titles, imageNames).map{ makeViewController(viewController: $0, title: $1, imageName: $2) }
    let nav1 = makeViewController(viewController: HomeViewController.self, title: "홈", imageName: "ic_home_tabbar")
    let nav2 = makeViewController(viewController: LikeViewController.self, title: "좋아요", imageName: "ic_like_tabbar")
    let nav3 = makeViewController(viewController: IDViewController.self, title: "", imageName: "id_card_tabbar")
    let nav4 = makeViewController(viewController: MyPageViewController.self, title: "캐릭터", imageName: "ic_jelly_tabbar")
    let nav5 = makeViewController(viewController: SettingViewController.self, title: "설정", imageName: "ic_more_tabbar")
    self.viewControllers = [nav1,nav2,nav3,nav4,nav5]
  }

  private func makeViewController(viewController: UIViewController.Type, title: String, imageName: String) -> UINavigationController {
    let viewController = viewController.init()
    let nav = UINavigationController(rootViewController: viewController)
    nav.tabBarItem = (imageName == "id_card_tabbar") ? UITabBarItem(title: title, image: UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), selectedImage: nil) : UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: nil)
    return nav
  }
}
