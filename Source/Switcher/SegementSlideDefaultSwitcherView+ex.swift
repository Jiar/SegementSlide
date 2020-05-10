//
//  SegementSlideDefaultSwitcherView+ex.swift
//  SegementSlide
//
//  Created by Jiar on 2020/5/6.
//

import UIKit

private var dataSourceKey: Void?

extension SegementSlideDefaultSwitcherView: SegementSlideSwitcherDelegate {
    
    public weak var ssDataSource: SegementSlideSwitcherDataSource? {
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
            defaultSelectedIndex = newValue
        }
    }
    
    public var ssSelectedIndex: Int? {
        return selectedIndex
    }
    
    public var ssScrollView: UIScrollView {
        return scrollView
    }
    
}
