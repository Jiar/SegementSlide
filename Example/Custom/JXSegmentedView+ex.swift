//
//  JXSegmentedView+ex.swift
//  Example
//
//  Created by Jiar on 2020/5/8.
//  Copyright © 2020 Jiar. All rights reserved.
//

import UIKit
import SegementSlide
import JXSegmentedView
    
private var dataSourceKey: Void?
    
extension JXSegmentedView: SegementSlideSwitcherDelegate {
    
    public var ssDataSource: SegementSlideSwitcherDataSource? {
        get {
            let weakBox = objc_getAssociatedObject(self, &dataSourceKey) as? SegementSlideSwitcherDataSourceWeakBox
            return weakBox?.unbox
        }
        set {
            objc_setAssociatedObject(self, &dataSourceKey, SegementSlideSwitcherDataSourceWeakBox(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var ssDefaultSelectedIndex: Int? {
        get {
            return defaultSelectedIndex
        }
        set {
            defaultSelectedIndex = newValue ?? 0
        }
    }
    
    public var ssSelectedIndex: Int? {
        return selectedIndex
    }
    
    public var ssScrollView: UIScrollView {
        return collectionView
    }

    public func selectItem(at index: Int, animated: Bool) {
        selectItemAt(index: index)
    }
    
}
