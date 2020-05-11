//
//  BaseSegementSlideDefaultViewController.swift
//  Example
//
//  Created by Jiar on 2018/12/13.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SegementSlide

class BaseSegementSlideDefaultViewController: SegementSlideDefaultViewController {
    
    override var switcherConfig: SegementSlideDefaultSwitcherConfig {
        return ConfigManager.shared.switcherConfig
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView, isParent: Bool) {
        super.scrollViewDidScroll(scrollView, isParent: isParent)
        guard isParent else {
            return
        }
        updateNavigationBarStyle(scrollView)
    }
    
    private func updateNavigationBarStyle(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > headerStickyHeight {
            switcherView.layer.applySketchShadow(color: .black, alpha: 0.03, x: 0, y: 2.5, blur: 5)
            switcherView.layer.add(generateFadeAnimation(), forKey: "reloadSwitcherView")
        } else {
            switcherView.layer.applySketchShadow(color: .clear, alpha: 0, x: 0, y: 0, blur: 0)
            switcherView.layer.add(generateFadeAnimation(), forKey: "reloadSwitcherView")
        }
    }
    
    private func generateFadeAnimation() -> CATransition {
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.25
        fadeTextAnimation.type = .fade
        return fadeTextAnimation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "more", style: .plain, target: self, action: #selector(moreAction))
    }
    
    @objc
    private func moreAction() {
        let viewController: UIViewController
        switch Int.random(in: 0..<9) {
        case 0..<4:
            viewController = NoticeViewController(selectedIndex: Int.random(in: 0..<DataManager.shared.noticeLanguageTitles.count))
        case 4:
            viewController = PostViewController(selectedIndex: Int.random(in: 0..<DataManager.shared.postLanguageTitles.count))
        case 5:
            viewController = HomeViewController()
        case 6:
            viewController = ExploreViewController()
        case 7:
            viewController = InterestViewController()
        case 8:
            viewController = MineViewController()
        default:
            viewController = UIViewController()
        }
        viewController.hidesBottomBarWhenPushed = Bool.random()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
