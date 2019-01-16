//
//  SegementSlideSwitcherConfig.swift
//  SegementSlide
//
//  Created by Jiar on 2019/1/16.
//  Copyright © 2019 Jiar. All rights reserved.
//

import UIKit

public class SegementSlideSwitcherConfig {
    
    public static let shared = SegementSlideSwitcherConfig()
    
    internal let type: SwitcherType
    internal let horizontalMargin: CGFloat
    internal let horizontalSpace: CGFloat
    internal let normalTitleFont: UIFont
    internal let selectedTitleFont: UIFont
    internal let normalTitleColor: UIColor
    internal let selectedTitleColor: UIColor
    internal let indicatorWidth: CGFloat
    internal let indicatorHeight: CGFloat
    internal let indicatorColor: UIColor
    internal let badgeHeightForCountType: CGFloat
    internal let badgeHeightForPointType: CGFloat
    internal let badgeFontSize: CGFloat
    
    public init(type: SwitcherType = .segement,
                horizontalMargin: CGFloat = 16,
                horizontalSpace: CGFloat = 32,
                normalTitleFont: UIFont = UIFont.systemFont(ofSize: 15),
                selectedTitleFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .medium),
                normalTitleColor: UIColor = UIColor.gray,
                selectedTitleColor: UIColor = UIColor.darkGray,
                indicatorWidth: CGFloat = 30,
                indicatorHeight: CGFloat = 2,
                indicatorColor: UIColor = UIColor.darkGray,
                badgeHeightForCountType: CGFloat = 15,
                badgeHeightForPointType: CGFloat = 9,
                badgeFontSize: CGFloat = 10) {
        self.type = type
        self.horizontalMargin = horizontalMargin
        self.horizontalSpace = horizontalSpace
        self.normalTitleFont = normalTitleFont
        self.selectedTitleFont = selectedTitleFont
        self.normalTitleColor = normalTitleColor
        self.selectedTitleColor = selectedTitleColor
        self.indicatorWidth = indicatorWidth
        self.indicatorHeight = indicatorHeight
        self.indicatorColor = indicatorColor
        self.badgeHeightForCountType = badgeHeightForCountType
        self.badgeHeightForPointType = badgeHeightForPointType
        self.badgeFontSize = badgeFontSize
    }
    
}
