//
//  SegementSlideViewController+delegate.swift
//  SegementSlide
//
//  Created by Jiar on 2019/1/16.
//  Copyright © 2019 Jiar. All rights reserved.
//

import UIKit

extension SegementSlideViewController: UIScrollViewDelegate {
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        guard let contentViewController = currentSegementSlideContentViewController else {
            return true
        }
        guard let scrollView = contentViewController.scrollView else {
            #if DEBUG
            if innerHeaderView != nil, innerHeaderHeight != nil {
                assert(false, "must implement this variable `scrollView` in protocol `SegementSlideContentScrollViewDelegate`")
            }
            #endif
            return true
        }
        scrollView.contentOffset.y = 0
        return true
    }
    
}

extension SegementSlideViewController: SegementSlideSwitcherViewDelegate {
    
    public var titlesInSegementSlideSwitcherView: [String] {
        return titlesInSwitcher
    }
    
    public func segementSwitcherView(_ segementSlideSwitcherView: SegementSlideSwitcherView, didSelectAtIndex index: Int, animated: Bool) {
        if segementSlideContentView.selectedIndex != index {
            segementSlideContentView.scrollToSlide(at: index, animated: animated)
        }
    }
    
    public func segementSwitcherView(_ segementSlideSwitcherView: SegementSlideSwitcherView, showBadgeAtIndex index: Int) -> BadgeType {
        return showBadgeInSwitcher(at: index)
    }
    
}

extension SegementSlideViewController: SegementSlideContentDelegate {
    
    public var segementSlideContentScrollViewCount: Int {
        return titlesInSwitcher.count
    }
    
    public func segementSlideContentScrollView(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        return segementSlideContentViewController(at: index)
    }
    
    public func segementSlideContentView(_ segementSlideContentView: SegementSlideContentView, didSelectAtIndex index: Int, animated: Bool) {
        if canCacheScrollState {
            if let selectedIndex = lastSelectedIndex {
                cachedScrollStates[selectedIndex] = (canParentViewScroll, canChildViewScroll, segementSlideScrollView.contentOffset.y)
            }
            if let canScrollState = cachedScrollStates[index] {
                canParentViewScroll = canScrollState.0
                canChildViewScroll = canScrollState.1
                if animated {
                    UIView.animate(withDuration: 0.25) {
                        self.segementSlideScrollView.contentOffset.y = canScrollState.2
                    }
                } else {
                    segementSlideScrollView.contentOffset.y = canScrollState.2
                }
            }
        } else {
            if let selectedIndex = lastSelectedIndex, let childScrollView = segementSlideContentView.segementSlideContentViewController(at: selectedIndex)?.scrollView {
                childScrollView.contentOffset.y = 0
            }
        }
        lastSelectedIndex = index
        if segementSlideSwitcherView.selectedIndex != index {
            segementSlideSwitcherView.selectSwitcher(at: index, animated: animated)
        }
        childKeyValueObservation?.invalidate()
        guard let childViewController = segementSlideContentView.segementSlideContentViewController(at: index) else { return }
        guard let scrollView = childViewController.scrollView else {
            #if DEBUG
            if innerHeaderView != nil, innerHeaderHeight != nil {
                assert(false, "must implement this variable `scrollView` in protocol `SegementSlideContentScrollViewDelegate`")
            }
            #endif
            return
        }
        let keyValueObservation = scrollView.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let self = self else { return }
            guard change.newValue != change.oldValue else { return }
            self.childScrollViewDidScroll(scrollView)
        })
        childKeyValueObservation = keyValueObservation
        didSelectContentViewController(at: index)
    }
    
}
