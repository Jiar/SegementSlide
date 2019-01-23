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
        return SegementSlideSwitcherConfig(type: .tab)
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
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "more", style: .plain, target: self, action: #selector(moreAction))
        reloadData()
        scrollToSlide(at: 1, animated: false)
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
