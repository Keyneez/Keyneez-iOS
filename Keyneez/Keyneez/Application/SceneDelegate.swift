//
//  SceneDelegate.swift
//  Keyneez
//
//  Created by Jung peter on 12/26/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    if let windowScene = scene as? UIWindowScene {
      
      let window = UIWindow(windowScene: windowScene)
      window.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
      
      let rootVC = JellyProductViewController()
      let navigationController = UINavigationController(rootViewController: rootVC)
      navigationController.navigationBar.isHidden = true

      window.rootViewController = navigationController
      window.makeKeyAndVisible()
      
//      let tabbarVC = LandingPageViewController()
//      window.rootViewController = tabbarVC
      window.makeKeyAndVisible()
      self.window = window
    }
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
  }
  
}
