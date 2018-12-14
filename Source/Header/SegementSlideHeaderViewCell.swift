//
//  SegementSlideHeaderViewCell.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SnapKit

internal class SegementSlideHeaderViewCell: UICollectionViewCell {
    
    private weak var lastHeaderView: UIView?
    private weak var segementSlideContentView: SegementSlideContentView?
    
    internal override func prepareForReuse() {
        super.prepareForReuse()
        if let lastHeaderView = lastHeaderView {
            lastHeaderView.removeFromSuperview()
        }
    }
    
    internal func config(_ headerView: UIView, segementSlideContentView: SegementSlideContentView) {
        self.segementSlideContentView = segementSlideContentView
        addSubview(headerView)
        headerView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        lastHeaderView = headerView
    }
    
    internal override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        guard let segementSlideContentView = segementSlideContentView else {
            return view
        }
        guard let selectedIndex = segementSlideContentView.selectedIndex,
            let segementSlideContentScrollViewDelegate = segementSlideContentView.segementSlideContentViewController(at: selectedIndex) else {
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
