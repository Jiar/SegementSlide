//
//  LanguageCenterViewController2.swift
//  Example
//
//  Created by Jiar on 2020/5/9.
//  Copyright © 2020 Jiar. All rights reserved.
//

import UIKit
import SegementSlide
import MBProgressHUD
import MJRefresh

class LanguageCenterViewController2: BaseTransparentSlideCustomViewController {
    
    private let id: Int
    private var badges: [Int: BadgeType] = [:]
    private var language: Language?
    private let centerHeaderView: LanguageCenterHeaderView
    private let isPresented: Bool
    
    init(id: Int, isPresented: Bool) {
        self.id = id
        self.isPresented = isPresented
        centerHeaderView = UINib(nibName: "LanguageCenterHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! LanguageCenterHeaderView
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var attributedTexts: DisplayEmbed<NSAttributedString?> {
        guard let language = language else {
            return (nil, nil)
        }
        return (nil, NSAttributedString(string: language.title, attributes: UINavigationBar.appearance().titleTextAttributes))
    }
    
    override var bouncesType: BouncesType {
        return .parent
    }
    
    override func segementSlideHeaderView() -> UIView {
        guard let _ = language else {
            let view = UIView()
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
            let headerHeight: CGFloat
            if #available(iOS 11.0, *) {
                headerHeight = view.bounds.height/4+view.safeAreaInsets.top
            } else {
                headerHeight = view.bounds.height/4+topLayoutGuide.length
            }
            view.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
            return view
        }
        return centerHeaderView
    }
    
    override var titlesInSwitcher: [String] {
        guard let _ = language else {
            return []
        }
        return DataManager.shared.languageCenterTitles
    }
    
    override var badgesInSwitcher: [Int] {
        guard let _ = language else {
            return []
        }
        let count = DataManager.shared.languageCenterTitles.count
        let badges = (0 ..< count).map({ _ in Int.random(in: 0..<10) })
        return badges
    }
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        guard let _ = language else {
            return nil
        }
        let viewController = ContentViewController()
        viewController.refreshHandler = { [weak self] in
            guard let self = self else {
                return
            }
            self.scrollView.mj_header.endRefreshing()
            self.reloadSwitcher()
        }
        return viewController
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topLayoutLength: CGFloat
        if #available(iOS 11.0, *) {
            topLayoutLength = view.safeAreaInsets.top
        } else {
            topLayoutLength = topLayoutGuide.length
        }
        scrollView.mj_header.ignoredScrollViewContentInsetTop = -topLayoutLength
    }
    
    @objc
    func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isPresented {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close")!, style: .plain, target: self, action: #selector(backAction))
        }
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
        scrollView.mj_header = refreshHeader
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        DispatchQueue.global().asyncAfter(deadline: .now()+Double.random(in: 0..<2)) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                if let language = DataManager.shared.language(by: self.id) {
                    hud.hide(animated: true)
                    self.language = language
                    self.centerHeaderView.config(language, viewController: self)
                    self.defaultSelectedIndex = 1
                    self.reloadData()
                } else {
                    hud.label.text = "Language not found!"
                    hud.hide(animated: true, afterDelay: 0.5)
                }
            }
        }
    }
    
    @objc
    private func refreshAction() {
        guard let contentViewController = currentSegementSlideContentViewController as? ContentViewController else {
            scrollView.mj_header.endRefreshing()
            return
        }
        contentViewController.refresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView, isParent: Bool) {
        super.scrollViewDidScroll(scrollView, isParent: isParent)
        guard isParent else {
            return
        }
        centerHeaderView.setBgImageTopConstraint(scrollView.contentOffset.y)
    }
    
}
