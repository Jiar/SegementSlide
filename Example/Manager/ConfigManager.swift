//
//  ConfigManager.swift
//  Example
//
//  Created by Jiar on 2019/3/25.
//  Copyright © 2019 Jiar. All rights reserved.
//

import UIKit
import SegementSlide

class ConfigManager {
    static let shared = ConfigManager()
    
    let switcherConfig: SegementSlideDefaultSwitcherConfig
    
    init() {
        switcherConfig = SegementSlideDefaultSwitcherConfig(normalTitleColor: UIColor.gray, selectedTitleColor: UIColor.darkGray, indicatorColor: UIColor.darkGray, badgeHeightForPointType: 9, badgeHeightForCountType: 15, badgeHeightForCustomType: 14)
    }
}
