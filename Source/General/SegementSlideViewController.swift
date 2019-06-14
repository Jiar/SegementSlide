//
//  SegementSlideViewController.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

public enum BouncesType {
    case parent
    case child
}

open class SegementSlideViewController: UIViewController {
    
    internal var segementSlideScrollView: SegementSlideScrollView!
    internal var segementSlideHeaderView: SegementSlideHeaderView!
    internal var segementSlideContentView: SegementSlideContentView!
    internal var segementSlideSwitcherView: SegementSlideSwitcherView!
    internal var innerHeaderView: UIView?
    
    internal var safeAreaTopConstraint: NSLayoutConstraint?
    internal var parentKeyValueObservation: NSKeyValueObservation?
    internal var childKeyValueObservation: NSKeyValueObservation?
    internal var innerBouncesType: BouncesType = .parent
    internal var canParentViewScroll: Bool = true
    internal var canChildViewScroll: Bool = false
    internal var lastChildBouncesTranslationY: CGFloat = 0
    internal var waitTobeResetContentOffsetY: Set<Int> = Set()
    
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
        let headerHeight = segementSlideHeaderView.frame.height.rounded(.up)
        if edgesForExtendedLayout.contains(.top) {
            return headerHeight - topLayoutLength
        } else {
            return headerHeight
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
        return segementSlideContentView.dequeueReusableViewController(at: currentIndex)
    }
    
    open var bouncesType: BouncesType {
        return .parent
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
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSegementSlideScrollView()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    /// reload headerView, SwitcherView and ContentView
    ///
    /// you should call `scrollToSlide(at index: Int, animated: Bool)` after call the method.
    /// otherwise, none of them will be selected.
    /// However, if an item was previously selected, it will be reSelected.
    public func reloadData() {
        setupBounces()
        setupHeader()
        setupSwitcher()
        waitTobeResetContentOffsetY.removeAll()
        segementSlideContentView.reloadData()
        segementSlideSwitcherView.reloadData()
        layoutSegementSlideScrollView()
    }
    
    /// reload headerView
    public func reloadHeader() {
        setupHeader()
        layoutSegementSlideScrollView()
    }
    
    /// reload SwitcherView
    public func reloadSwitcher() {
        setupSwitcher()
        segementSlideSwitcherView.reloadData()
        layoutSegementSlideScrollView()
    }
    
    /// reload badges in SwitcherView
    public func reloadBadgeInSwitcher() {
        segementSlideSwitcherView.reloadBadges()
    }
    
    /// reload ContentView
    public func reloadContent() {
        waitTobeResetContentOffsetY.removeAll()
        segementSlideContentView.reloadData()
    }
    
    /// select one item by index
    public func scrollToSlide(at index: Int, animated: Bool) {
        segementSlideSwitcherView.selectSwitcher(at: index, animated: animated)
    }
    
    /// reuse the `SegementSlideContentScrollViewDelegate`
    public func dequeueReusableViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        return segementSlideContentView.dequeueReusableViewController(at: index)
    }
    
    deinit {
        parentKeyValueObservation?.invalidate()
        childKeyValueObservation?.invalidate()
        NotificationCenter.default.removeObserver(self, name: SegementSlideContentView.willClearAllReusableViewControllersNotification, object: nil)
        #if DEBUG
        debugPrint("\(type(of: self)) deinit")
        #endif
    }
    
}
