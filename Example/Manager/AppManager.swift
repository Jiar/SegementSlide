//
//  AppManager.swift
//  Example
//
//  Created by Jiar on 2018/12/14.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

class AppManager {
    static let shared = AppManager()
    
    let rootController: UITabBarController
    
    init() {
        rootController = UITabBarController()
        let homeViewController = HomeViewController()
        let exploreViewController = ExploreViewController()
        let mineViewController = MineViewController()
        rootController.viewControllers = [UINavigationController(rootViewController: homeViewController), UINavigationController(rootViewController: exploreViewController), UINavigationController(rootViewController: mineViewController)]
    }
    
    func setup() {
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
    }
}
