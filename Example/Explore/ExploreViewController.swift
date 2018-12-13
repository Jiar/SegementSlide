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
        title = "发现"
        tabBarItem = UITabBarItem(title: "发现", image: UIImage(named: "tab_explore")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_explore_sel")?.withRenderingMode(.alwaysOriginal))
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
        headerView.contentMode = .scaleAspectFill
        headerView.image = UIImage(named: "bg_languages.jpg")
        return headerView
    }
    
    override var switcherType: SwitcherType {
        return .segement
    }
    
    override func titlesInSwitcher() -> [String] {
        return DataManager.shared.exploreLanguageTitles
    }
    
    override func showBadgeInSwitcher(at index: Int) -> BadgeType {
        return .none
    }
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        switch index {
        case 0:
            return ContentViewController()
        case 1:
            return ContentViewController()
        case 2:
            return ContentViewController()
        case 3:
            return ContentViewController()
        case 4:
            return ContentViewController()
        case 5:
            return ContentViewController()
        case 6:
            return ContentViewController()
        case 7:
            return ContentViewController()
        case 8:
            return ContentViewController()
        case 9:
            return ContentViewController()
        case 10:
            return ContentViewController()
        default:
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        reloadHeader()
        reloadSwitcher()
    }

}
