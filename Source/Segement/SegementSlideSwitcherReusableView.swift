//
//  SegementSlideSwitcherReusableView.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

internal class SegementSlideSwitcherReusableView: UICollectionReusableView {
    
    internal func config(_ segementSlideSwitcherView: SegementSlideSwitcherView) {
        NSLayoutConstraint.deactivate(segementSlideSwitcherView.constraints)
        //segementSlideSwitcherView.removeConstraints(segementSlideSwitcherView.constraints)
        segementSlideSwitcherView.removeFromSuperview()
        addSubview(segementSlideSwitcherView)
        NSLayoutConstraint.activate([
            segementSlideSwitcherView.topAnchor.constraint(equalTo: topAnchor),
            segementSlideSwitcherView.bottomAnchor.constraint(equalTo: bottomAnchor),
            segementSlideSwitcherView.leadingAnchor.constraint(equalTo: leadingAnchor),
            segementSlideSwitcherView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
