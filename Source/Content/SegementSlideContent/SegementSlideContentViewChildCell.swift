//
//  SegementSlideContentViewChildCell.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SnapKit

internal class SegementSlideContentViewChildCell: UICollectionViewCell {
    
    private weak var lastSubViewController: UIViewController?
    
    internal override func prepareForReuse() {
        super.prepareForReuse()
        if let lastSubViewController = lastSubViewController {
            lastSubViewController.view.removeFromSuperview()
            lastSubViewController.removeFromParent()
        }
    }
    
    internal func config(viewController: SegementSlideViewController, childViewController: SegementSlideContentScrollViewDelegate) {
        guard let subViewController = childViewController as? UIViewController else { return }
        viewController.addChild(subViewController)
        addSubview(subViewController.view)
        subViewController.view.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        lastSubViewController = subViewController
    }
    
}
