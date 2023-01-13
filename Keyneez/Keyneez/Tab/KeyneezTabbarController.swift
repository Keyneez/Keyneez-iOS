//
//  KeyneezTabbarController.swift
//  Keyneez
//
//  Created by Jung peter on 12/26/22.
//

import UIKit
import Then

private struct TabInfo {
  var viewController: UIViewController.Type?
  var title: String = ""
  var imageName: String = ""
}

final class KeyneezTabbarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    assignTabbar()
    createTabbarItems()
  }
  
//  let repository = KeyneezContentRepository()

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
    
//    let homeViewController = HomeViewController()
//    let homeViewNavigationController = makeHomeNaviController(homeViewController: homeViewController)
//
//    guard let token = UserSession.shared.accessToken else { return }
//    repository.getAllContents(token: token) {
//      [weak self] arr in
//      homeViewController.datasources.append(arr)
//      DispatchQueue.main.async {
//        homeViewController.VCs.forEach {
//          $0.contentList = homeViewController.datasources[0]
//        }
//      }
//    }
    
    let tabInfos: [TabInfo] = [
      TabInfo(viewController: HomeViewController.self, title: "홈", imageName: "ic_home_tabbar"),
      TabInfo(viewController: LikeViewController.self, title: "좋아요", imageName: "ic_like_tabbar"),
      TabInfo(viewController: IDViewController.self, imageName: "id_card_tabbar"),
      TabInfo(viewController: MyPageViewController.self, title: "캐릭터",
              imageName: "ic_jelly_tabbar"),
      TabInfo(viewController: SettingViewController.self, title: "설정",
              imageName: "ic_more_tabbar")
    ]
    var navigations = tabInfos.map {
      makeViewController(viewController: $0.viewController!, title: $0.title, imageName: $0.imageName)
    }
    navigations[3].tabBarItem.isEnabled = false
    navigations[4].tabBarItem.isEnabled = false
//    navigations.insert(homeViewNavigationController, at: 0)
    self.viewControllers = navigations
  }

  private func makeViewController(viewController: UIViewController.Type,
                                  title: String, imageName: String) -> UINavigationController {
    let viewController = viewController.init()
    let nav = UINavigationController(rootViewController: viewController)
    nav.isNavigationBarHidden = true
    nav.tabBarItem = (imageName == "id_card_tabbar") ?
    UITabBarItem(title: title, image:
                  UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal),
                 selectedImage: nil) :
    UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: nil)
    return nav
  }
  
//  private func makeHomeNaviController(homeViewController: HomeViewController) -> UINavigationController {
//    let nav = UINavigationController(rootViewController: homeViewController)
//    nav.isNavigationBarHidden = true
//    nav.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "ic_home_tabbar"), selectedImage: nil)
//    return nav
//  }
}
