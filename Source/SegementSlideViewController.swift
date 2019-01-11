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
    internal private(set) var segementSlideScrollView: SegementSlideScrollView!
    internal private(set) var segementSlideHeaderView: SegementSlideHeaderView!
    internal private(set) var segementSlideSwitcherView: SegementSlideSwitcherView!
    internal private(set) var segementSlideContentView: SegementSlideContentView!
    internal private(set) var innerHeaderHeight: CGFloat?
    internal private(set) var innerHeaderView: UIView?
    private var headerViewTopConstraint: Constraint?
    private var contentViewHeightConstraint: Constraint?
    private var parentKeyValueObservation: NSKeyValueObservation!
    private var childKeyValueObservation: NSKeyValueObservation?
    private var innerBouncesType: BouncesType = .parent
    private var canParentViewScroll: Bool = true
    private var canChildViewScroll: Bool = false
    private var lastTranslationY: CGFloat = 0
    
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
        if !edgesForExtendedLayout.contains(.top) {
            return innerHeaderHeight
        } else {
            return innerHeaderHeight-topLayoutLength
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
    
    open func headerHeight() -> CGFloat? {
        if !edgesForExtendedLayout.contains(.top) {
            return nil
        } else {
            assert(false, "must override this function")
            return nil
        }
    }
    
    open func headerView() -> UIView? {
        if !edgesForExtendedLayout.contains(.top) {
            return nil
        } else {
            assert(false, "must override this function")
            return nil
        }
    }
    
    open var switcherType: SwitcherType {
        return .segement
    }
    
    open var switcherHeight: CGFloat {
        return 44
    }
    
    open func titlesInSwitcher() -> [String] {
        assert(false, "must override this function")
        return []
    }
    
    open func showBadgeInSwitcher(at index: Int) -> BadgeType {
        return .none
    }
    
    open var horizontalMarginInSwitcher: CGFloat {
        return 16
    }
    
    open var horizontalSpaceInSwitcher: CGFloat {
        return 22
    }
    
    open var normalTitleFontInSwitcher: UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    
    open var selectedTitleFontInSwitcher: UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    open var normalTitleColorInSwitcher: UIColor {
        return UIColor.gray
    }
    
    open var selectedTitleColorInSwitcher: UIColor {
        return UIColor.darkGray
    }
    
    open var indicatorWidthInSwitcher: CGFloat {
        return 30
    }
    
    open var indicatorHeightInSwitcher: CGFloat {
        return 2
    }
    
    open var indicatorColorInSwitcher: UIColor {
        return UIColor.darkGray
    }
    
    open func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        assert(false, "must override this function")
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
        contentViewHeightConstraint?.update(offset: contentViewHeight)
        if !edgesForExtendedLayout.contains(.top) {
            headerViewTopConstraint?.update(offset: topLayoutLength)
            segementSlideScrollView.contentSize = CGSize(width: view.bounds.width, height: topLayoutLength+(innerHeaderHeight ?? 0)+switcherHeight+contentViewHeight+1)
        } else {
            headerViewTopConstraint?.update(offset: 0)
            segementSlideScrollView.contentSize = CGSize(width: view.bounds.width, height: (innerHeaderHeight ?? 0)+switcherHeight+contentViewHeight+1)
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
        innerHeaderView?.snp.removeConstraints()
        innerHeaderView?.removeFromSuperview()
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

extension SegementSlideViewController {
    
    private func setup() {
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = []
        setupSegementSlideHeaderView()
        setupSegementSlideSwitcherView()
        setupSegementSlideContentView()
        setupSegementSlideScrollView()
    }
    
    private func setupSegementSlideHeaderView() {
        segementSlideHeaderView = SegementSlideHeaderView()
        segementSlideHeaderView.backgroundColor = .clear
    }
    
    private func setupSegementSlideSwitcherView() {
        segementSlideSwitcherView = SegementSlideSwitcherView()
        segementSlideSwitcherView.delegate = self
    }
    
    private func setupSegementSlideContentView() {
        segementSlideContentView = SegementSlideContentView()
        segementSlideContentView.delegate = self
        segementSlideContentView.viewController = self
    }
    
    private func setupSegementSlideScrollView() {
        segementSlideScrollView = SegementSlideScrollView()
        view.addSubview(segementSlideScrollView)
        segementSlideScrollView.snp.remakeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        if #available(iOS 11.0, *) {
            segementSlideScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        segementSlideScrollView.backgroundColor = .white
        segementSlideScrollView.showsHorizontalScrollIndicator = false
        segementSlideScrollView.showsVerticalScrollIndicator = false
        segementSlideScrollView.delegate = self
        segementSlideScrollView.isPagingEnabled = false
        segementSlideScrollView.isScrollEnabled = true
        view.backgroundColor = .white
        parentKeyValueObservation = segementSlideScrollView.observe(\.contentOffset, options: [.initial, .new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let self = self else { return }
            guard change.newValue != change.oldValue else { return }
            self.parentScrollViewDidScroll(scrollView)
        })
    }
    
    private func setupBounces() {
        innerBouncesType = bouncesType
        switch innerBouncesType {
        case .parent:
            canParentViewScroll = true
            canChildViewScroll = false
        case .child:
            canParentViewScroll = true
            canChildViewScroll = true
        }
    }
    
    private func setupHeader() {
        innerHeaderHeight = headerHeight()?.rounded(.up)
        innerHeaderView = headerView()
    }
    
    private func setupSwitcher() {
        segementSlideSwitcherView.type = switcherType
        segementSlideSwitcherView.horizontalMargin = horizontalMarginInSwitcher
        segementSlideSwitcherView.horizontalSpace = horizontalSpaceInSwitcher
        segementSlideSwitcherView.normalTitleFont = normalTitleFontInSwitcher
        segementSlideSwitcherView.selectedTitleFont = selectedTitleFontInSwitcher
        segementSlideSwitcherView.normalTitleColor = normalTitleColorInSwitcher
        segementSlideSwitcherView.selectedTitleColor = selectedTitleColorInSwitcher
        segementSlideSwitcherView.indicatorWidth = indicatorWidthInSwitcher
        segementSlideSwitcherView.indicatorHeight = indicatorHeightInSwitcher
        segementSlideSwitcherView.indicatorColor = indicatorColorInSwitcher
    }
    
    private func layoutSegementSlideScrollView() {
        for subview in segementSlideScrollView.subviews {
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
        if let innerHeaderView = innerHeaderView, let innerHeaderHeight = innerHeaderHeight {
            segementSlideScrollView.addSubview(segementSlideHeaderView)
            segementSlideHeaderView.snp.remakeConstraints { make in
                headerViewTopConstraint = make.top.equalTo(segementSlideScrollView.snp.top).constraint
                make.leading.equalTo(view.snp.leading)
                make.trailing.equalTo(view.snp.trailing)
                make.height.equalTo(innerHeaderHeight)
            }
            segementSlideHeaderView.config(innerHeaderView, segementSlideContentView: segementSlideContentView)
        }
        segementSlideScrollView.addSubview(segementSlideContentView)
        segementSlideScrollView.addSubview(segementSlideSwitcherView)
        segementSlideSwitcherView.snp.remakeConstraints { make in
            if let _ = innerHeaderView {
                make.top.equalTo(segementSlideHeaderView.snp.bottom).priority(999)
            } else {
                headerViewTopConstraint = make.top.equalTo(segementSlideScrollView.snp.top).priority(999).constraint
            }
            if #available(iOS 11, *) {
                make.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.greaterThanOrEqualTo(topLayoutGuide.snp.bottom)
            }
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(switcherHeight)
        }
        segementSlideContentView.snp.remakeConstraints { make in
            make.top.equalTo(segementSlideSwitcherView.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            contentViewHeightConstraint = make.height.equalTo(contentViewHeight).constraint
        }
    }
    
}

extension SegementSlideViewController: UIScrollViewDelegate {
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        guard let contentViewController = currentSegementSlideContentViewController else {
            return true
        }
        contentViewController.scrollView.contentOffset.y = 0
        return true
    }
    
}

extension SegementSlideViewController: SegementSlideSwitcherViewDelegate {
    
    internal func titlesInSegementSlideSwitcherView() -> [String] {
        return titlesInSwitcher()
    }
    
    internal func segementSwitcherView(_ segementSlideSwitcherView: SegementSlideSwitcherView, didSelectAtIndex index: Int, animated: Bool) {
        if segementSlideContentView.selectedIndex != index {
            segementSlideContentView.scrollToSlide(at: index, animated: animated)
        }
    }
    
    internal func segementSwitcherView(_ segementSlideSwitcherView: SegementSlideSwitcherView, showBadgeAtIndex index: Int) -> BadgeType {
        return showBadgeInSwitcher(at: index)
    }
    
}

extension SegementSlideViewController: SegementSlideContentDelegate {
    
    internal var segementSlideContentScrollViewCount: Int {
        return titlesInSwitcher().count
    }
    
    internal func segementSlideContentScrollView(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        return segementSlideContentViewController(at: index)
    }
    
    internal func segementSlideContentView(_ segementSlideContentView: SegementSlideContentView, didSelectAtIndex index: Int, animated: Bool) {
        if segementSlideSwitcherView.selectedIndex != index {
            segementSlideSwitcherView.selectSwitcher(at: index, animated: animated)
        }
        childKeyValueObservation?.invalidate()
        guard let childViewController = segementSlideContentView.segementSlideContentViewController(at: index) else { return }
        let keyValueObservation = childViewController.scrollView.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let self = self else { return }
            guard change.newValue != change.oldValue else { return }
            self.childScrollViewDidScroll(scrollView)
        })
        childKeyValueObservation = keyValueObservation
        didSelectContentViewController(at: index)
    }
    
}

extension SegementSlideViewController {
    
    private func parentScrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScroll(scrollView, isParent: true)
        let translationY = -scrollView.panGestureRecognizer.translation(in: scrollView).y
        defer {
            lastTranslationY = translationY
        }
        let parentContentOffsetX = segementSlideScrollView.contentOffset.x
        let parentContentOffsetY = segementSlideScrollView.contentOffset.y
        switch innerBouncesType {
        case .parent:
            if !canParentViewScroll {
                segementSlideScrollView.contentOffset = CGPoint(x: parentContentOffsetX, y: headerStickyHeight)
                canChildViewScroll = true
            } else if parentContentOffsetY >= headerStickyHeight {
                segementSlideScrollView.contentOffset = CGPoint(x: parentContentOffsetX, y: headerStickyHeight)
                canParentViewScroll = false
                canChildViewScroll = true
            }
        case .child:
            if !canParentViewScroll {
                segementSlideScrollView.contentOffset = CGPoint(x: parentContentOffsetX, y: headerStickyHeight)
                canChildViewScroll = true
            } else if parentContentOffsetY >= headerStickyHeight {
                segementSlideScrollView.contentOffset = CGPoint(x: parentContentOffsetX, y: headerStickyHeight)
                canParentViewScroll = false
                canChildViewScroll = true
            } else if parentContentOffsetY <= 0 {
                segementSlideScrollView.contentOffset = CGPoint(x: parentContentOffsetX, y: 0)
                canChildViewScroll = true
            } else {
                guard let childScrollView = currentSegementSlideContentViewController?.scrollView else { return }
                if childScrollView.contentOffset.y < 0 {
                    if translationY > lastTranslationY {
                        segementSlideScrollView.contentOffset = CGPoint(x: parentContentOffsetX, y: 0)
                        canChildViewScroll = true
                    } else {
                        canChildViewScroll = false
                    }
                } else {
                    canChildViewScroll = false
                }
            }
        }
    }
    
    private func childScrollViewDidScroll(_ childScrollView: UIScrollView) {
        scrollViewDidScroll(childScrollView, isParent: false)
        let parentContentOffsetY = segementSlideScrollView.contentOffset.y
        let childContentOffsetX = childScrollView.contentOffset.x
        let childContentOffsetY = childScrollView.contentOffset.y
        switch innerBouncesType {
        case .parent:
            if !canChildViewScroll {
                childScrollView.contentOffset = CGPoint(x: childContentOffsetX, y: 0)
            } else if childContentOffsetY <= 0 {
                canChildViewScroll = false
                canParentViewScroll = true
            }
        case .child:
            if !canChildViewScroll {
                childScrollView.contentOffset = CGPoint(x: childContentOffsetX, y: 0)
            } else if childContentOffsetY <= 0 {
                if parentContentOffsetY <= 0 {
                    canChildViewScroll = true
                }
                canParentViewScroll = true
            } else {
                if parentContentOffsetY > 0 && parentContentOffsetY < headerStickyHeight {
                    canChildViewScroll = false
                }
            }
        }
    }
    
}

extension SegementSlideViewController {
    
    internal var topLayoutLength: CGFloat {
        let topLayoutLength: CGFloat
        if #available(iOS 11, *) {
            topLayoutLength = view.safeAreaInsets.top
        } else {
            topLayoutLength = topLayoutGuide.length
        }
        return topLayoutLength
    }
    
    internal var bottomLayoutLength: CGFloat {
        let bottomLayoutLength: CGFloat
        if #available(iOS 11, *) {
            bottomLayoutLength = view.safeAreaInsets.bottom
        } else {
            bottomLayoutLength = bottomLayoutGuide.length
        }
        return bottomLayoutLength
    }
    
}

internal class SegementSlideScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
