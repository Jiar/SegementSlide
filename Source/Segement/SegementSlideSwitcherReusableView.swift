//
//  SegementSlideSwitcherReusableView.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SnapKit

internal class SegementSlideSwitcherReusableView: UICollectionReusableView {
    
    private weak var lastSegementSlideSwitcherView: SegementSlideSwitcherView?
    
    internal override func prepareForReuse() {
        super.prepareForReuse()
        if let lastSegementSlideSwitcherView = lastSegementSlideSwitcherView {
            lastSegementSlideSwitcherView.removeFromSuperview()
        }
    }
    
    internal func config(_ segementSlideSwitcherView: SegementSlideSwitcherView) {
        addSubview(segementSlideSwitcherView)
        segementSlideSwitcherView.snp.remakeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        lastSegementSlideSwitcherView = segementSlideSwitcherView
    }
    
}
