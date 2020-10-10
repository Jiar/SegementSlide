//
//  NoticeViewController.swift
//  Example
//
//  Created by Jiar on 2019/1/19.
//  Copyright © 2019 Jiar. All rights reserved.
//

import UIKit
import SegementSlide
import SnapKit

class NoticeViewController: UIViewController {
    
    private var segementSlideSwitcherView: SegementSlideDefaultSwitcherView!
    private var segementSlideContentView: SegementSlideContentView!
    
    var defaultSelectedIndex: Int? {
        set {
            segementSlideSwitcherView.defaultSelectedIndex = newValue
            segementSlideContentView.defaultSelectedIndex = newValue
        }
        get {
            return segementSlideSwitcherView.defaultSelectedIndex
        }
    }
    
    private var badges: [Int: BadgeType] = [:]
    private let selectedIndex: Int
    
    init(selectedIndex: Int = 0) {
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard segementSlideSwitcherView.superview != nil else {
            return
        }
        segementSlideSwitcherView.snp.remakeConstraints { make in
            make.center.height.equalToSuperview()
            make.width.equalTo(segementSlideSwitcherView.intrinsicContentSize.width)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "more", style: .plain, target: self, action: #selector(moreAction))
        setupSwitcherView()
        setupContentView()
        defaultSelectedIndex = selectedIndex
        reloadData()
    }
    
    private func setupSwitcherView() {
        segementSlideSwitcherView = SegementSlideDefaultSwitcherView()
        segementSlideSwitcherView.config = SegementSlideDefaultSwitcherConfig(type: .segement, horizontalMargin: 28)
        segementSlideSwitcherView.delegate = self
        
        let size: CGSize
        if let navigationBar = navigationController?.navigationBar {
            size = CGSize(width: navigationBar.bounds.width*0.6, height: navigationBar.bounds.height)
        } else {
            size = CGSize(width: view.bounds.width*0.6, height: 44)
        }
        let titleView = UIView()
        titleView.backgroundColor = .clear
        if #available(iOS 11, *) {
            titleView.snp.makeConstraints { make in
                make.size.equalTo(size)
            }
        } else {
            titleView.frame = CGRect(origin: .zero, size: size)
        }
        
        titleView.addSubview(segementSlideSwitcherView)
        segementSlideSwitcherView.snp.makeConstraints { make in
            make.height.equalTo(size.height)
            make.width.equalTo(segementSlideSwitcherView.intrinsicContentSize.width)
        }
        navigationItem.titleView = titleView
    }
    
    private func setupContentView() {
        segementSlideContentView = SegementSlideContentView()
        segementSlideContentView.delegate = self
        segementSlideContentView.viewController = self
        view.addSubview(segementSlideContentView)
        segementSlideContentView.snp.makeConstraints { make in
            make.top.leading.trailing.height.equalToSuperview()
        }
    }
    
    public func reloadData() {
        segementSlideContentView.reloadData()
        segementSlideSwitcherView.reloadData()
    }
    
    public func selectItem(at index: Int, animated: Bool) {
        segementSlideSwitcherView.selectItem(at: index, animated: animated)
    }
    
    @objc
    private func moreAction() {
        let viewController: UIViewController
        switch Int.random(in: 0..<8) {
        case 0..<4:
            viewController = NoticeViewController(selectedIndex: Int.random(in: 0..<DataManager.shared.noticeLanguageTitles.count))
        case 4:
            viewController = PostViewController(selectedIndex: Int.random(in: 0..<DataManager.shared.postLanguageTitles.count))
        case 5:
            viewController = HomeViewController()
        case 6:
            viewController = ExploreViewController()
        case 7:
            viewController = MineViewController()
        default:
            viewController = NoticeViewController(selectedIndex: Int.random(in: 0..<DataManager.shared.noticeLanguageTitles.count))
        }
        viewController.hidesBottomBarWhenPushed = Bool.random()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    deinit {
        debugPrint("\(type(of: self)) deinit")
    }
    
}

extension NoticeViewController: SegementSlideDefaultSwitcherViewDelegate {
    
    public var titlesInSegementSlideSwitcherView: [String] {
        return DataManager.shared.noticeLanguageTitles
    }
    
    public func segementSwitcherView(_ segementSlideSwitcherView: SegementSlideDefaultSwitcherView, didSelectAtIndex index: Int, animated: Bool) {
        if segementSlideContentView.selectedIndex != index {
            segementSlideContentView.selectItem(at: index, animated: animated)
        }
    }
    
    public func segementSwitcherView(_ segementSlideSwitcherView: SegementSlideDefaultSwitcherView, showBadgeAtIndex index: Int) -> BadgeType {
        if let badge = badges[index] {
            return badge
        } else {
            let badge = BadgeType.random
            badges[index] = badge
            return badge
        }
    }
    
}

extension NoticeViewController: SegementSlideContentDelegate {
    
    public var segementSlideContentScrollViewCount: Int {
        return titlesInSegementSlideSwitcherView.count
    }
    
    public func segementSlideContentScrollView(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        let viewController = ContentOptionalViewController()
        viewController.refreshHandler = { [weak self] in
            guard let self = self else {
                return
            }
            self.badges[index] = BadgeType.random
            self.segementSlideSwitcherView.reloadBadges()
        }
        return viewController
    }
    
    public func segementSlideContentView(_ segementSlideContentView: SegementSlideContentView, didSelectAtIndex index: Int, animated: Bool) {
        if segementSlideSwitcherView.selectedIndex != index {
            segementSlideSwitcherView.selectItem(at: index, animated: animated)
        }
    }
    
}
