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
    
    override func headerHeight() -> CGFloat {
        return view.bounds.height/4
    }
    
    override func headerView() -> UIView {
        let headerView = UIImageView()
        headerView.isUserInteractionEnabled = true
        headerView.contentMode = .scaleAspectFill
        headerView.image = UIImage(named: "bg_think.jpeg")
        return headerView
    }
    
    override var switcherType: SwitcherType {
        return .tab
    }
    
    override func titlesInSwitcher() -> [String] {
        return DataManager.shared.homeLanguageTitles
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
