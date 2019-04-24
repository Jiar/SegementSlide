//
//  SegementSlideHeaderView.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import WebKit

internal class SegementSlideHeaderView: UIView {
    
    private weak var lastHeaderView: UIView?
    private weak var segementSlideContentView: SegementSlideContentView?
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
    }
    
    internal func config(_ headerView: UIView?, segementSlideContentView: SegementSlideContentView) {
        if let lastHeaderView = lastHeaderView {
            lastHeaderView.removeAllConstraints()
            lastHeaderView.removeFromSuperview()
        }
        guard let headerView = headerView else { return }
        self.segementSlideContentView = segementSlideContentView
        addSubview(headerView)
        headerView.constraintToSuperview()
        lastHeaderView = headerView
    }
    
    internal override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        guard let segementSlideContentView = segementSlideContentView else {
            return view
        }
        guard let selectedIndex = segementSlideContentView.selectedIndex,
            let segementSlideContentScrollViewDelegate = segementSlideContentView.segementSlideContentViewController(at: selectedIndex)
            else {
            return view
        }
        if view is UIControl {
            return view
        }
        /// WKWebView也需要响应内部点击事件,比如视频播放
        var _superView: UIView? = view?.superview
        while _superView != nil {
            if !(_superView is WKWebView) {
                _superView = _superView?.superview
            } else {
                return view
            }
        }
        if !(view?.gestureRecognizers?.isEmpty ?? true) {
            return view
        }
        return segementSlideContentScrollViewDelegate.scrollView
    }
    
}
