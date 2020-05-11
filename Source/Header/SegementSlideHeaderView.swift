//
//  SegementSlideHeaderView.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

public class SegementSlideHeaderView: UIView {
    
    private weak var lastHeaderView: UIView?
    private weak var contentView: SegementSlideContentView?
    
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
    
    internal func config(_ headerView: UIView?, contentView: SegementSlideContentView) {
        guard headerView != lastHeaderView else {
            return
        }
        if let lastHeaderView = lastHeaderView {
            lastHeaderView.removeAllConstraints()
            lastHeaderView.removeFromSuperview()
        }
        guard let headerView = headerView else {
            return
        }
        self.contentView = contentView
        addSubview(headerView)
        headerView.constraintToSuperview()
        lastHeaderView = headerView
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        guard let contentView = contentView else {
            return view
        }
        guard let selectedIndex = contentView.selectedIndex,
            let delegate = contentView.dequeueReusableViewController(at: selectedIndex) else {
            return view
        }
        if view is UIControl {
            return view
        }
        if !(view?.gestureRecognizers?.isEmpty ?? true) {
            return view
        }
        return delegate.scrollView
    }
    
}
