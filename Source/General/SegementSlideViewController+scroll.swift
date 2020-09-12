//
//  SegementSlideViewController+scroll.swift
//  SegementSlide
//
//  Created by Jiar on 2019/1/16.
//  Copyright © 2019 Jiar. All rights reserved.
//

import UIKit

extension SegementSlideViewController {
    
    internal func parentScrollViewDidScroll(_ parentScrollView: UIScrollView) {
        defer {
            scrollViewDidScroll(parentScrollView, isParent: true)
        }
        let parentContentOffsetY = parentScrollView.contentOffset.y
        switch innerBouncesType {
        case .parent:
            if !canParentViewScroll {
                parentScrollView.contentOffset.y = headerStickyHeight
                canChildViewScroll = true
            } else if parentContentOffsetY >= headerStickyHeight {
                parentScrollView.contentOffset.y = headerStickyHeight
                canParentViewScroll = false
                canChildViewScroll = true
            } else {
                resetOtherCachedChildViewControllerContentOffsetY()
            }
        case .child:
            let childBouncesTranslationY = -parentScrollView.panGestureRecognizer.translation(in: parentScrollView).y.rounded(.up)
            defer {
                lastChildBouncesTranslationY = childBouncesTranslationY
            }
            if !canParentViewScroll {
                parentScrollView.contentOffset.y = headerStickyHeight
                canChildViewScroll = true
            } else if parentContentOffsetY >= headerStickyHeight {
                parentScrollView.contentOffset.y = headerStickyHeight
                canParentViewScroll = false
                canChildViewScroll = true
            } else if parentContentOffsetY <= 0 {
                parentScrollView.contentOffset.y = 0
                canChildViewScroll = true
                resetOtherCachedChildViewControllerContentOffsetY()
            } else {
                guard let childScrollView = currentSegementSlideContentViewController?.scrollView else {
                    resetOtherCachedChildViewControllerContentOffsetY()
                    return
                }
                if childScrollView.contentOffset.y < 0 {
                    if childBouncesTranslationY > lastChildBouncesTranslationY {
                        scrollView.contentOffset.y = 0
                        canChildViewScroll = true
                    } else {
                        canChildViewScroll = false
                    }
                } else {
                    canChildViewScroll = false
                }
                resetOtherCachedChildViewControllerContentOffsetY()
            }
        }
    }
    
    internal func childScrollViewDidScroll(_ childScrollView: UIScrollView) {
        defer {
            scrollViewDidScroll(childScrollView, isParent: false)
        }
        let parentContentOffsetY = scrollView.contentOffset.y
        let childContentOffsetY = childScrollView.contentOffset.y
        switch innerBouncesType {
        case .parent:
            if !canChildViewScroll {
                childScrollView.contentOffset.y = 0
            } else if childContentOffsetY <= 0 {
                canChildViewScroll = false
                canParentViewScroll = true
            }
        case .child:
            if !canChildViewScroll {
                childScrollView.contentOffset.y = 0
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
