//
//  SegementSlideSwitcherDataSourceWeakBox.swift
//  SegementSlide
//
//  Created by Jiar on 2020/5/8.
//

import UIKit

final public class SegementSlideSwitcherDataSourceWeakBox {
    
    public private(set) weak var unbox: SegementSlideSwitcherDataSource?
    public init(_ value: SegementSlideSwitcherDataSource?) {
        unbox = value
    }
    
}
