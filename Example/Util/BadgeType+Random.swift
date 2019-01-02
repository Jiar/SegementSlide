//
//  BadgeType+Random.swift
//  Example
//
//  Created by Jiar on 2018/12/29.
//  Copyright © 2018 Jiar. All rights reserved.
//

import SegementSlide

extension BadgeType: CaseIterable {
    
    public static var allCases: [BadgeType] {
        return [.none, .point, .count(1), .count(3), .count(6), .count(10), .count(15),
                .count(21), .count(28), .count(36), .count(99), .count(888), .count(1001)]
    }
    
    public static var random: BadgeType {
        let index = Int(arc4random_uniform(UInt32(BadgeType.allCases.count)))
        return BadgeType.allCases[index]
    }
    
}
