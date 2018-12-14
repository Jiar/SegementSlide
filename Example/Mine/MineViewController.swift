//
//  MineViewController.swift
//  Example
//
//  Created by Jiar on 2018/12/12.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SegementSlide

class MineViewController: TransparentTabSlideViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Mine"
        tabBarItem = UITabBarItem(title: "Mine", image: UIImage(named: "tab_mine")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_mine_sel")?.withRenderingMode(.alwaysOriginal))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var attributedTexts: DisplayEmbed<NSAttributedString?> {
        return (display: nil, embed: NSAttributedString(string: "Mine", attributes: UINavigationBar.appearance().titleTextAttributes))
    }
    
    override var bouncesType: BouncesType {
        return .parent
    }
    
    override func headerHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            return view.bounds.height/4+view.safeAreaInsets.top
        } else {
            return view.bounds.height/4+topLayoutGuide.length
        }
    }
    
    override func headerView() -> UIView {
        let headerView = UIImageView()
        headerView.isUserInteractionEnabled = true
        headerView.contentMode = .scaleAspectFill
        headerView.image = UIImage(named: "bg_computer.png")
        return headerView
    }
    
    override var switcherType: SwitcherType {
        return .tab
    }
    
    override func titlesInSwitcher() -> [String] {
        return DataManager.shared.mineLanguageTitles
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
        default:
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        reloadHeader()
        reloadSwitcher()
        scrollToSlide(at: 1, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reloadHeader()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView, isParent: Bool) {
        super.scrollViewDidScroll(scrollView, isParent: isParent)
        guard isParent else { return }
        if scrollView.contentOffset.y <= -view.bounds.height/3 {
            scrollView.contentOffset.y = -view.bounds.height/3
        }
        updateNavigationBarStyle(scrollView)
    }
    
    private func updateNavigationBarStyle(_ scrollView: UIScrollView) {
        guard headerStickyHeight != 0 else { return }
        if scrollView.contentOffset.y >= headerStickyHeight {
            slideSwitcherView.layer.applySketchShadow(color: .black, alpha: 0.03, x: 0, y: 2.5, blur: 5)
            slideSwitcherView.layer.add(generateFadeAnimation(), forKey: "reloadSwitcherView")
        } else {
            slideSwitcherView.layer.applySketchShadow(color: .clear, alpha: 0, x: 0, y: 0, blur: 0)
            slideSwitcherView.layer.add(generateFadeAnimation(), forKey: "reloadSwitcherView")
        }
    }
    
    private func generateFadeAnimation() -> CATransition {
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.25
        fadeTextAnimation.type = .fade
        return fadeTextAnimation
    }

}
