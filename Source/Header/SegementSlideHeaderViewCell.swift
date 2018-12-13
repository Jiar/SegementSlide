//
//  SegementSlideHeaderViewCell.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

internal class SegementSlideHeaderViewCell: UICollectionViewCell {
    
    private weak var segementSlideContentView: SegementSlideContentView?
    
    internal func config(_ headerView: UIView, segementSlideContentView: SegementSlideContentView) {
        self.segementSlideContentView = segementSlideContentView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(headerView.constraints)
        //headerView.removeConstraints(headerView.constraints)
        headerView.removeFromSuperview()
        addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
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
