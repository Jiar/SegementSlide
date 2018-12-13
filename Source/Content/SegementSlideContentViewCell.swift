//
//  SegementSlideContentViewCell.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

internal class SegementSlideContentViewCell: UICollectionViewCell {
    
    internal func config(_ segementSlideContentView: SegementSlideContentView) {
        NSLayoutConstraint.deactivate(segementSlideContentView.constraints)
        //segementSlideContentView.removeConstraints(segementSlideContentView.constraints)
        segementSlideContentView.removeFromSuperview()
        addSubview(segementSlideContentView)
        NSLayoutConstraint.activate([
            segementSlideContentView.topAnchor.constraint(equalTo: topAnchor),
            segementSlideContentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            segementSlideContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            segementSlideContentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
