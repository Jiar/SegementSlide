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
    
    override var headerHeight: CGFloat? {
        return view.bounds.height/4
    }
    
    override var headerView: UIView? {
        let headerView = UIImageView()
        headerView.isUserInteractionEnabled = true
        headerView.contentMode = .scaleAspectFill
        headerView.image = UIImage(named: "bg_working.png")
        return headerView
    }
    
    override var switcherConfig: SegementSlideSwitcherConfig {
        return SegementSlideSwitcherConfig(type: .segement)
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
        canCacheScrollState = Bool.random()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "more", style: .plain, target: self, action: #selector(moreAction))
        reloadData()
        scrollToSlide(at: 0, animated: false)
    }
   
    
    @objc private func moreAction() {
        let viewController: UIViewController
        switch Int.random(in: 0..<8) {
        case 0..<5:
            viewController = NoticeViewController(selectedIndex: Int.random(in: 0..<2))
        case 5:
            viewController = HomeViewController()
        case 6:
            viewController = ExploreViewController()
        case 7:
            viewController = MineViewController()
        default:
            viewController = NoticeViewController(selectedIndex: Int.random(in: 0..<2))
        }
        viewController.hidesBottomBarWhenPushed = Bool.random()
        navigationController?.pushViewController(viewController, animated: true)
    }

}

/// Full Explore View Controller
class FullExploreViewController: ExploreViewController {
    
    let statusBar = UIView(frame: .zero)
    override init() {
        super.init()
        title = "Full Screen"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var statusBarHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            statusBarHeight = self.view.safeAreaInsets.top
        } else {
            statusBarHeight = self.topLayoutGuide.length
        }
        self.statusBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: statusBarHeight)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusBar.backgroundColor = UIColor.init(red: 177.0 / 255.0, green: 206.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
        self.view.addSubview(self.statusBar)
        self.statusBar.alpha = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override var innerHeaderTopLength: CGFloat? { return 0 }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.statusBar.alpha = scrollView.contentOffset.y / self.headerStickyHeight
    }
}
