//
//  SegementSlideDefaultSwitcherView+ex.swift
//  SegementSlide
//
//  Created by Jiar on 2020/5/6.
//

import UIKit

final private class WeakBox {
    weak var unbox: SegementSlideSwitcherDataSource?
    init(_ value: SegementSlideSwitcherDataSource?) {
        unbox = value
    }
}

private var dataSourceKey: Void?

extension SegementSlideDefaultSwitcherView: SegementSlideSwitcherDelegate {
    
    public weak var dataSource: SegementSlideSwitcherDataSource? {
        get {
            let weakBox = objc_getAssociatedObject(self, &dataSourceKey) as? WeakBox
            return weakBox?.unbox
        }
        set {
            objc_setAssociatedObject(self, &dataSourceKey, WeakBox(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
