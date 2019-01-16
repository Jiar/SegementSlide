//
//  SegementSlideViewController.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SnapKit

public enum BouncesType {
    case parent
    case child
}

open class SegementSlideViewController: UIViewController {
    
    internal var segementSlideScrollView: SegementSlideScrollView!
    internal var segementSlideHeaderView: SegementSlideHeaderView!
    internal var segementSlideContentView: SegementSlideContentView!
    internal var segementSlideSwitcherView: SegementSlideSwitcherView!
    internal var innerHeaderHeight: CGFloat?
    internal var innerHeaderView: UIView?
    
    internal var headerViewTopConstraint: Constraint?
    internal var contentViewHeightConstraint: Constraint?
    internal var parentKeyValueObservation: NSKeyValueObservation!
    internal var childKeyValueObservation: NSKeyValueObservation?
    internal var innerBouncesType: BouncesType = .parent
    internal var canParentViewScroll: Bool = true
    internal var canChildViewScroll: Bool = false
    internal var lastTranslationY: CGFloat = 0
    
    public var slideScrollView: UIScrollView {
        return segementSlideScrollView
    }
    public var slideSwitcherView: UIView {
        return segementSlideSwitcherView
    }
    public var slideContentView: UIView {
        return segementSlideContentView
    }
    public var headerStickyHeight: CGFloat {
        guard let innerHeaderHeight = innerHeaderHeight else {
            return 0
        }
        if edgesForExtendedLayout.contains(.top) {
            return innerHeaderHeight-topLayoutLength
        } else {
            return innerHeaderHeight
        }
    }
    public var contentViewHeight: CGFloat {
        return view.bounds.height-topLayoutLength-switcherHeight
    }
    public var currentIndex: Int? {
        return segementSlideSwitcherView.selectedIndex
    }
    public var currentSegementSlideContentViewController: SegementSlideContentScrollViewDelegate? {
        guard let currentIndex = currentIndex else { return nil }
        return segementSlideContentView.segementSlideContentViewController(at: currentIndex)
    }
    
    open var bouncesType: BouncesType {
        return .parent
    }
    
    open var headerHeight: CGFloat? {
        if edgesForExtendedLayout.contains(.top) {
            #if DEBUG
            assert(false, "must override this variable")
            #endif
            return nil
        } else {
            return nil
        }
    }
    
    open var headerView: UIView? {
        if edgesForExtendedLayout.contains(.top) {
            #if DEBUG
            assert(false, "must override this variable")
            #endif
            return nil
        } else {
            return nil
        }
    }
    
    open var switcherHeight: CGFloat {
        return 44
    }
    
    open var switcherConfig: SegementSlideSwitcherConfig {
        return SegementSlideSwitcherConfig.shared
    }
    
    open var titlesInSwitcher: [String] {
        #if DEBUG
        assert(false, "must override this variable")
        #endif
        return []
    }
    
    open func showBadgeInSwitcher(at index: Int) -> BadgeType {
        return .none
    }
    
    open func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        #if DEBUG
        assert(false, "must override this function")
        #endif
        return nil
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView, isParent: Bool) {
        
    }
    
    open func didSelectContentViewController(at index: Int) {
        
    }
    
    public func scrollToSlide(at index: Int, animated: Bool) {
        segementSlideSwitcherView.selectSwitcher(at: index, animated: animated)
    }
    
    public func contentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        return segementSlideContentView.segementSlideContentViewController(at: index)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSegementSlideScrollView()
        segementSlideHeaderView.layer.zPosition = -3
        segementSlideContentView.layer.zPosition = -2
        segementSlideSwitcherView.layer.zPosition = -1
        contentViewHeightConstraint?.update(offset: contentViewHeight)
        if edgesForExtendedLayout.contains(.top) {
            headerViewTopConstraint?.update(offset: 0)
            segementSlideScrollView.contentSize = CGSize(width: view.bounds.width, height: (innerHeaderHeight ?? 0)+switcherHeight+contentViewHeight+1)
        } else {
            headerViewTopConstraint?.update(offset: topLayoutLength)
            segementSlideScrollView.contentSize = CGSize(width: view.bounds.width, height: topLayoutLength+(innerHeaderHeight ?? 0)+switcherHeight+contentViewHeight+1)
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    public func reloadData() {
        setupBounces()
        setupHeader()
        setupSwitcher()
        segementSlideContentView.reloadData()
        segementSlideSwitcherView.reloadData()
        layoutSegementSlideScrollView()
    }
    
    public func reloadHeader() {
        setupHeader()
        layoutSegementSlideScrollView()
    }
    
    public func reloadSwitcher() {
        setupSwitcher()
        segementSlideSwitcherView.reloadData()
        layoutSegementSlideScrollView()
    }
    
    public func reloadBadgeInSwitcher() {
        segementSlideSwitcherView.reloadBadges()
    }
    
    public func reloadContent() {
        segementSlideContentView.reloadData()
    }
    
    deinit {
        #if DEBUG
        print("\(type(of: self)) deinit")
        #endif
    }
    
}

