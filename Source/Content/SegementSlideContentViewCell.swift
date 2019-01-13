//
//  SegementSlideContentViewCell.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SnapKit

internal class SegementSlideContentViewCell: UICollectionViewCell {
    
    private weak var lastSegementSlideContentView: SegementSlideContentView?
    
    internal override func prepareForReuse() {
        super.prepareForReuse()
        if let lastSegementSlideContentView = lastSegementSlideContentView {
            lastSegementSlideContentView.removeFromSuperview()
        }
    }
    
    internal func config(_ segementSlideContentView: SegementSlideContentView) {
        addSubview(segementSlideContentView)
        segementSlideContentView.snp.remakeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        lastSegementSlideContentView = segementSlideContentView
    }
    
}
