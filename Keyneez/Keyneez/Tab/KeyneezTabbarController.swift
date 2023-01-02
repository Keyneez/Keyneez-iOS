//
//  KeyneezTabbarController.swift
//  Keyneez
//
//  Created by Jung peter on 12/26/22.
//

import UIKit

//TODO: 이 부분은 내가 그냥 더미로 만들어뒀는데 지워야해
class HomeViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
  }
}

class CameraViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .yellow
  }
}

class ProfileViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
  }
}

final class KeyneezTabbarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    assignTabbar()
    createTabbarItems()
    setupMiddleButton()
  }
  
  private func assignTabbar() {
    let tabBar = { () -> KeyneezTabar in
             let tabBar = KeyneezTabar()
             tabBar.delegate = self
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
//    let imageNames = ["hosse.circle", "house.circle", "person.circle", "person.circle"]
//    let navigations = zip(viewControllers, titles, imageNames).map{ makeViewController(viewController: $0, title: $1, imageName: $2) }
    let nav1 = makeViewController(viewController: HomeViewController.self, title: "홈", imageName: "house.circle")
    let nav2 = makeViewController(viewController: CameraViewController.self, title: "좋아요", imageName: "house.circle")
    let nav3 = makeViewController(viewController: ProfileViewController.self, title: "", imageName: "person.circle")
    let nav4 = makeViewController(viewController: ProfileViewController.self, title: "캐릭터", imageName: "person.circle")
    let nav5 = makeViewController(viewController: ProfileViewController.self, title: "설정", imageName: "person.circle")
    self.viewControllers = [nav1,nav2,nav3,nav4,nav5]
  }
  
  private func makeViewController(viewController: UIViewController.Type, title: String, imageName: String) -> UINavigationController {
    let viewController = viewController.init()
    let nav = UINavigationController(rootViewController: viewController)
    nav.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), selectedImage: nil)
    return nav
  }
}

// MARK: - Middle Button
extension KeyneezTabbarController {
  
  private func setupMiddleButton() {
    //TODO: Asset이 나왔는지 모르겠는데, 이거 변경해야해
    let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -20, width: 50, height: 50))
    middleButton.backgroundColor = .black
    self.tabBar.addSubview(middleButton)
    middleButton.addAction(didTouchMiddleButton(), for: .touchUpInside)
    self.view.layoutIfNeeded()
  }
  
  private func didTouchMiddleButton() -> UIAction {
    return UIAction { _ in
      guard let viewControllers = self.viewControllers else {
        self.selectedIndex = 2
        return
      }
      self.selectedIndex = viewControllers.count / 2
    }
  }
}
