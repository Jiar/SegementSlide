//
//  SegementSlideContentViewChildCell.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

internal class SegementSlideContentViewChildCell: UICollectionViewCell {
    
    internal func config(viewController: SegementSlideViewController, childViewController: SegementSlideContentScrollViewDelegate) {
        guard let subViewController = childViewController as? UIViewController else { return }
        subViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(subViewController.view.constraints)
        //subViewController.view.removeConstraints(subViewController.view.constraints)
        subViewController.view.removeFromSuperview()
        subViewController.removeFromParent()
        addSubview(subViewController.view)
        viewController.addChild(subViewController)
        NSLayoutConstraint.activate([
            subViewController.view.topAnchor.constraint(equalTo: topAnchor),
            subViewController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            subViewController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            subViewController.view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
