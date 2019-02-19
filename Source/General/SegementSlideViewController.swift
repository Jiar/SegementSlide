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
    internal var innerHeaderHeight: CGFloat?
    internal var innerHeaderView: UIView?
    
    internal var safeAreaTopConstraint: NSLayoutConstraint?
    internal var parentKeyValueObservation: NSKeyValueObservation!
    internal var childKeyValueObservation: NSKeyValueObservation?
    internal var innerBouncesType: BouncesType = .parent
    internal var canParentViewScroll: Bool = true
    internal var canChildViewScroll: Bool = false
    internal var lastChildBouncesTranslationY: CGFloat = 0
    
    internal var lastSelectedIndex: Int? = nil
    /// canParentViewScroll, canChildViewScroll, segementSlideScrollView.contentOffset.y
    internal var cachedScrollStates: [Int: (Bool, Bool, CGFloat)] = [:]
    
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
            return innerHeaderHeight - topLayoutLength
        } else {
            return innerHeaderHeight - (innerHeaderTopLength != nil ? topLayoutLength : 0)
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
    
    /// true: cache the headerView(the root scrollView) and each childViewController's scrollView's contentOffset.y.
    /// false: when toggling childViewController, resets scrollview's contentoffset.y.
    /// default value is false.
    open var canCacheScrollState: Bool = false
    
    open var bouncesType: BouncesType {
        return .parent
    }
    
    /// the value should contains topLayoutGuide's length(safeAreaInsets.top in iOS 11), if the edgesForExtendedLayout in viewController contains `.top`
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
    /// the distance between header and root scrollview
    open var innerHeaderTopLength: CGFloat? { return nil }
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
        clearCachedScrollStates()
        setupBounces()
        setupHeader()
        setupSwitcher()
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
        segementSlideContentView.reloadData()
    }
    
    /// select one item by index
    public func scrollToSlide(at index: Int, animated: Bool) {
        segementSlideSwitcherView.selectSwitcher(at: index, animated: animated)
    }
    
    /// reuse the `SegementSlideContentScrollViewDelegate`
    public func contentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        return segementSlideContentView.segementSlideContentViewController(at: index)
    }
    
    deinit {
        #if DEBUG
        print("\(type(of: self)) deinit")
        #endif
    }
    
}
