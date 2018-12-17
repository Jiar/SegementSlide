//
//  CGFloat+Decimals.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/17.
//

extension CGFloat {
    
    var keep3: CGFloat {
        return floor(self*1000)/1000
    }
}

