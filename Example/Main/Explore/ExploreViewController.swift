//
//  ExploreViewController.swift
//  Example
//
//  Created by Jiar on 2018/12/12.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SegementSlide

class ExploreViewController: BaseSegementSlideViewController {

    private var badges: [Int: BadgeType] = [:]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Explore"
        tabBarItem = UITabBarItem(title: "Explore", image: UIImage(named: "tab_explore")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_explore_sel")?.withRenderingMode(.alwaysOriginal))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var headerView: UIView? {
        let headerView = UIImageView()
        headerView.isUserInteractionEnabled = true
        headerView.contentMode = .scaleAspectFill
        headerView.image = UIImage(named: "bg_working.png")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return headerView
    }
    
    override var switcherConfig: SegementSlideSwitcherConfig {
        var config = super.switcherConfig
        config.type = .segement
        return config
    }
    
    override var titlesInSwitcher: [String] {
        return DataManager.shared.exploreLanguageTitles
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
        reloadData()
        scrollToSlide(at: 0, animated: false)
    }

}
