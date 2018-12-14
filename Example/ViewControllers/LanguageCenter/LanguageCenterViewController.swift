//
//  LanguageCenterViewController.swift
//  Example
//
//  Created by Jiar on 2018/12/14.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SegementSlide
import MBProgressHUD

class LanguageCenterViewController: TransparentTabSlideViewController {
    
    private let id: Int
    private var language: Language?
    private let centerHeaderView: LanguageCenterHeaderView
    private var limitContentOffsetY: CGFloat {
        return -(centerHeaderView.bgImageViewHeight-headerHeight())
    }
    
    init(id: Int) {
        self.id = id
        centerHeaderView = UINib(nibName: "LanguageCenterHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! LanguageCenterHeaderView
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
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
        guard let _ = language else {
            return 0
        }
        return centerHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }
    
    override func headerView() -> UIView {
        guard let _ = language else {
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }
        return centerHeaderView
    }
    
    override var switcherType: SwitcherType {
        return .tab
    }
    
    override func titlesInSwitcher() -> [String] {
        guard let _ = language else {
            return []
        }
        return DataManager.shared.mineLanguageTitles
    }
    
    override func showBadgeInSwitcher(at index: Int) -> BadgeType {
        guard let _ = language else {
            return .none
        }
        switch index {
        case 0:
            return .count(8)
        default:
            return .none
        }
    }
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        guard let _ = language else {
            return nil
        }
        return ContentViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        DispatchQueue.global().asyncAfter(deadline: .now()+1.2) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let language = DataManager.shared.language(by: self.id) {
                    hud.hide(animated: true)
                    self.language = language
                    self.centerHeaderView.config(language, viewController: self)
                    self.reloadData()
                    self.scrollToSlide(at: 1, animated: false)
                } else {
                    hud.label.text = "Language not found!"
                    hud.hide(animated: true, afterDelay: 0.5)
                }
            }
        }
    }
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        reloadHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView, isParent: Bool) {
        super.scrollViewDidScroll(scrollView, isParent: isParent)
        guard isParent else { return }
        if scrollView.contentOffset.y <= limitContentOffsetY {
            scrollView.contentOffset.y = limitContentOffsetY
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
