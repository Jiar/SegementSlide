//
//  SegementSlideHeaderView.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SnapKit

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
            lastHeaderView.snp.removeConstraints()
            lastHeaderView.removeFromSuperview()
        }
        guard let headerView = headerView else { return }
        self.segementSlideContentView = segementSlideContentView
        addSubview(headerView)
        headerView.snp.remakeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
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
        if !(view?.gestureRecognizers?.isEmpty ?? true) {
            return view
        }
        return segementSlideContentScrollViewDelegate.scrollView
    }
    
}
