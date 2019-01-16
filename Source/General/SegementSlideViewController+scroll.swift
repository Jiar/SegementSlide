//
//  SegementSlideViewController+scroll.swift
//  SegementSlide
//
//  Created by Jiar on 2019/1/16.
//  Copyright © 2019 Jiar. All rights reserved.
//

import UIKit

extension SegementSlideViewController {
    
    internal func parentScrollViewDidScroll(_ scrollView: UIScrollView) {
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
    
    internal func childScrollViewDidScroll(_ childScrollView: UIScrollView) {
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
