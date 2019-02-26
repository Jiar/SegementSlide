//
//  PostViewController.swift
//  Example
//
//  Created by Jiar on 2019/2/17.
//  Copyright © 2019 Jiar. All rights reserved.
//

import UIKit
import SegementSlide

class PostViewController: BaseSegementSlideViewController {
    
    private var badges: [Int: BadgeType] = [:]
    private let selectedIndex: Int
    
    init(selectedIndex: Int = 0) {
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
        title = "Post"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var switcherConfig: SegementSlideSwitcherConfig {
        return SegementSlideSwitcherConfig(type: .tab)
    }
    
    override var titlesInSwitcher: [String] {
        return DataManager.shared.postLanguageTitles
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
        let viewController = ContentOptionalViewController()
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
        scrollToSlide(at: selectedIndex, animated: false)
    }
    
}
