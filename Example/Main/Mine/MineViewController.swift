//
//  MineViewController.swift
//  Example
//
//  Created by Jiar on 2018/12/12.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SegementSlide

class MineViewController: BaseTransparentSlideViewController {

    private var badges: [Int: BadgeType] = [:]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Mine", image: UIImage(named: "tab_mine")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_mine_sel")?.withRenderingMode(.alwaysOriginal))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var attributedTexts: DisplayEmbed<NSAttributedString?> {
        return (nil, NSAttributedString(string: "Mine", attributes: UINavigationBar.appearance().titleTextAttributes))
    }
    
    override var tintColors: DisplayEmbed<UIColor> {
        return (.black, .black)
    }
    
    override var bouncesType: BouncesType {
        return .child
    }
    
    override var headerHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return view.bounds.height/4+view.safeAreaInsets.top
        } else {
            return view.bounds.height/4+topLayoutGuide.length
        }
    }
    
    override var headerView: UIView {
        let headerView = UIImageView()
        headerView.isUserInteractionEnabled = true
        headerView.contentMode = .scaleAspectFill
        headerView.image = UIImage(named: "bg_computer.png")
        return headerView
    }
    
    override var switcherConfig: SegementSlideSwitcherConfig {
        var config = super.switcherConfig
        config.type = .tab
        return config
    }
    
    override var titlesInSwitcher: [String] {
        return DataManager.shared.mineLanguageTitles
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
        scrollToSlide(at: 1, animated: false)
    }

}
