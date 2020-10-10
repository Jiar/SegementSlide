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
        guard let contentViewController = currentSegementSlideContentViewController,
            let scrollView = contentViewController.scrollView else {
            return true
        }
        scrollView.contentOffset.y = 0
        return true
    }
    
}

extension SegementSlideViewController: SegementSlideContentDelegate {
    
    public var segementSlideContentScrollViewCount: Int {
        return switcherView.ssDataSource?.titles.count ?? 0
    }
    
    public func segementSlideContentScrollView(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        return segementSlideContentViewController(at: index)
    }
    
    public func segementSlideContentView(_ segementSlideContentView: SegementSlideContentView, didSelectAtIndex index: Int, animated: Bool) {
        waitTobeResetContentOffsetY.insert(index)
        if switcherView.ssSelectedIndex != index {
            switcherView.selectItem(at: index, animated: animated)
        }
        childKeyValueObservation?.invalidate()
        guard let childViewController = segementSlideContentView.dequeueReusableViewController(at: index) else {
            return
        }
        defer {
            didSelectContentViewController(at: index)
        }
        guard let scrollView = childViewController.scrollView else {
            return
        }
        let keyValueObservation = scrollView.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let self = self else {
                return
            }
            guard change.newValue != change.oldValue else {
                return
            }
            self.childScrollViewDidScroll(scrollView)
        })
        childKeyValueObservation = keyValueObservation
    }
    
}
