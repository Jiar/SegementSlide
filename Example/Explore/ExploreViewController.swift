//
//  ExploreViewController.swift
//  Example
//
//  Created by Jiar on 2018/12/12.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SegementSlide

class ExploreViewController: ShadowSegementSlideViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Explore"
        tabBarItem = UITabBarItem(title: "Explore", image: UIImage(named: "tab_explore")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_explore_sel")?.withRenderingMode(.alwaysOriginal))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var bouncesType: BouncesType {
        return .parent
    }
    
    override func headerHeight() -> CGFloat {
        return view.bounds.height/4
    }
    
    override func headerView() -> UIView {
        let headerView = UIImageView()
        headerView.isUserInteractionEnabled = true
        headerView.contentMode = .scaleAspectFill
        headerView.image = UIImage(named: "bg_working.png")
        return headerView
    }
    
    override var switcherType: SwitcherType {
        return .segement
    }
    
    override func titlesInSwitcher() -> [String] {
        return DataManager.shared.exploreLanguageTitles
    }
    
    override func showBadgeInSwitcher(at index: Int) -> BadgeType {
        switch index {
        case 0:
            return .none
        case 1:
            return .none
        case 2:
            return .none
        case 3:
            return .point
        case 4:
            return .count(6)
        default:
            return .none
        }
    }
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        return ContentViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}
