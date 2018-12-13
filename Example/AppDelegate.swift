//
//  AppDelegate.swift
//  Example
//
//  Created by Jiar on 2018/12/12.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        let backImage = UIImage(named: "top_back")
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationBar.tintColor = UIColor(red: 77/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1.0)
        navigationBar.barTintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .white
        let footShadowImage = UIImage(named: "foot_shadow")
        UITabBar.appearance().shadowImage = footShadowImage
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 0/255.0, green: 188/255.0, blue: 212/255.0, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .medium)], for: .selected)
        
        let rootController = UITabBarController()
        let homeViewController = HomeViewController()
        let exploreViewController = ExploreViewController()
        let mineViewController = MineViewController()
        rootController.viewControllers = [UINavigationController(rootViewController: homeViewController), UINavigationController(rootViewController: exploreViewController), UINavigationController(rootViewController: mineViewController)]
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = rootController
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

