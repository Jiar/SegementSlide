//
//  HomeViewController.swift
//  Example
//
//  Created by Jiar on 2018/12/12.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SegementSlide

class HomeViewController: ShadowSegementSlideViewController {
    
    private var badges: [Int: BadgeType] = [:]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Home"
        tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tab_home")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_home_sel")?.withRenderingMode(.alwaysOriginal))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var bouncesType: BouncesType {
        return .child
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView, isParent: Bool) {
        guard !isParent else { return }
        guard let navigationController = navigationController else { return }
        let translationY = -scrollView.panGestureRecognizer.translation(in: scrollView).y
        if translationY > 0 {
            guard !navigationController.isNavigationBarHidden else { return }
            navigationController.setNavigationBarHidden(true, animated: true)
        } else {
            guard !scrollView.isTracking else { return }
            guard navigationController.isNavigationBarHidden else { return }
            navigationController.setNavigationBarHidden(false, animated: true)
        }
    }
    
    override var switcherConfig: SegementSlideSwitcherConfig {
        return SegementSlideSwitcherConfig(type: .tab)
    }
    
    override var titlesInSwitcher: [String] {
        return DataManager.shared.homeLanguageTitles
    }
    
    override func showBadgeInSwitcher(at index: Int) -> BadgeType {
        if let badge = badges[index] {
            return badge
        } else {
            let badge = BadgeType.random
            badges[index] = badge
            return badge
        }
    }
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        let viewController = ContentViewController()
        viewController.refreshHandler = { [weak self] in
            guard let self = self else { return }
            self.badges[index] = BadgeType.random
            self.reloadBadgeInSwitcher()
        }
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "more", style: .plain, target: self, action: #selector(moreAction))
        reloadData()
        scrollToSlide(at: 0, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func moreAction() {
        let viewController: UIViewController
        switch Int.random(in: 0..<3) {
        case 0:
            viewController = HomeViewController()
        case 1:
            viewController = ExploreViewController()
        case 2:
            viewController = MineViewController()
        default:
            viewController = HomeViewController()
        }
        viewController.hidesBottomBarWhenPushed = Bool.random()
        navigationController?.pushViewController(viewController, animated: true)
    }

}
