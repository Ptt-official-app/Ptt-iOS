//
//  SceneDelegate.swift
//  Ptt
//
//  Created by denkeni on 2020/1/7.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

struct RootViewControllerProvider {

    static func tabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        let tabItemFavorite = UITabBarItem(title: NSLocalizedString("Favorite Boards", comment: ""), image: nil, tag: 0)
        let favoriteViewController = FavoriteViewController()
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)
        favoriteNavigationController.tabBarItem = tabItemFavorite
        let tabItemHot = UITabBarItem(title: NSLocalizedString("Hot Topics", comment: ""), image: nil, tag: 1)
        let hotTopicViewController = UIViewController()
        hotTopicViewController.tabBarItem = tabItemHot
        tabBarController.viewControllers = [favoriteNavigationController, hotTopicViewController]
        return tabBarController
    }
}

struct GlobalAppearance {

    static func apply(to window: UIWindow) {
        if #available(iOS 11.0, *) {
            window.tintColor = UIColor(named: "tintColor-255-159-10")
        } else {
            window.tintColor = UIColor(red: 255/255, green: 159/255, blue: 10/255, alpha: 1.0)
        }
        if #available(iOS 13.0, *) {
        } else {
            let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white]
            UINavigationBar.appearance().titleTextAttributes = attrs
            if #available(iOS 11.0, *) {
                UINavigationBar.appearance().barTintColor = UIColor(named: "blackColor-23-23-23")
                UITabBar.appearance().barTintColor = UIColor(named: "blackColor-23-23-23")
                UINavigationBar.appearance().largeTitleTextAttributes = attrs
            } else {
                UINavigationBar.appearance().barTintColor = UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1.0)
                UITabBar.appearance().barTintColor = UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1.0)
            }
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }

    static var backgroundColor : UIColor? {
        if #available(iOS 11.0, *) {
            return UIColor(named: "blackColor-23-23-23")
        } else {
            return UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1.0)
        }
    }
}

extension UINavigationController {

    /// Only required for iOS 12 or earlier
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            // TODO: user preference for UserInterfaceStyle
            // For forward compatibility
//            return .darkContent
        }
        return .lightContent
    }
}

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = RootViewControllerProvider.tabBarController()
        // TODO: user preference for UserInterfaceStyle
        window.overrideUserInterfaceStyle = .dark
        GlobalAppearance.apply(to: window)
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

