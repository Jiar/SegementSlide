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
import MJRefresh

class LanguageCenterViewController: ShadowTransparentTabSlideViewController {
    
    private let id: Int
    private var badges: [Int: BadgeType] = [:]
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
        guard let language = language else {
            return (display: nil, embed: nil)
        }
        return (display: nil, embed: NSAttributedString(string: language.title, attributes: UINavigationBar.appearance().titleTextAttributes))
    }
    
    override var bouncesType: BouncesType {
        return .parent
    }
    
    override func headerHeight() -> CGFloat {
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
        if let badge = badges[index] {
            return badge
        } else {
            let badge = BadgeType.random
            badges[index] = badge
            return badge
        }
    }
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        guard let _ = language else {
            return nil
        }
        let viewController = ContentViewController()
        viewController.refreshHandler = { [weak self] in
            guard let self = self else { return }
            self.slideScrollView.mj_header.endRefreshing()
            self.badges[index] = BadgeType.random
            self.reloadBadgeInSwitcher()
        }
        return viewController
    }
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        reloadHeader()
        slideScrollView.mj_header.ignoredScrollViewContentInsetTop = -view.safeAreaInsets.top
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreAction))
        let refreshHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))!
        refreshHeader.lastUpdatedTimeLabel.isHidden = true
        refreshHeader.arrowView.image = nil
        refreshHeader.labelLeftInset = 0
        refreshHeader.activityIndicatorViewStyle = .white
        refreshHeader.setTitle("", for: .idle)
        refreshHeader.setTitle("", for: .noMoreData)
        refreshHeader.setTitle("", for: .pulling)
        refreshHeader.setTitle("", for: .refreshing)
        refreshHeader.setTitle("", for: .willRefresh)
        slideScrollView.mj_header = refreshHeader
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        DispatchQueue.global().asyncAfter(deadline: .now()+Double.random(in: 0..<3)) {
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
    
    @objc private func refreshAction() {
        guard let contentViewController = currentSegementSlideContentViewController as? ContentViewController else {
            slideScrollView.mj_header.endRefreshing()
            return
        }
        contentViewController.refresh()
    }
    
    @objc private func moreAction() {
        let viewController: UIViewController
        switch Int.random(in: 0..<3) {
        case 0:
            viewController = HomeViewController()
        case 1:
            viewController = ExploreViewController()
        case 2:
            viewController = MineViewController()
        default:
            viewController = HomeViewController()
        }
        navigationController?.pushViewController(viewController, animated: true)
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
        centerHeaderView.setBgImageTopConstraint(scrollView.contentOffset.y)
    }
    
}
