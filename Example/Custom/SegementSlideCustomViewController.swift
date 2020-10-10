//
//  SegementSlideCustomViewController.swift
//  Example
//
//  Created by Jiar on 2020/5/8.
//  Copyright © 2020 Jiar. All rights reserved.
//

import UIKit
import SegementSlide
import JXSegmentedView

open class SegementSlideCustomViewController: SegementSlideViewController {
    
    private let segmentedView = JXSegmentedView()
    
    private lazy var segmentedDataSource: JXSegmentedNumberDataSource = {
        let dataSource = JXSegmentedNumberDataSource()
        dataSource.titleSelectedColor = .white
        dataSource.isTitleColorGradientEnabled = true
        dataSource.isItemSpacingAverageEnabled = true
        dataSource.isSelectedAnimable = true
        dataSource.isTitleMaskEnabled = true
        return dataSource
    }()
    
    public override func segementSlideSwitcherView() -> SegementSlideSwitcherDelegate {
        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorColor = .purple
        segmentedView.indicators = [indicator]
        segmentedView.delegate = self
        segmentedView.ssDataSource = self
        return segmentedView
    }
    
    open override func setupSwitcher() {
        super.setupSwitcher()
        segmentedDataSource.titles = titlesInSwitcher
        segmentedDataSource.numbers = badgesInSwitcher
        segmentedView.dataSource = segmentedDataSource
        segmentedView.contentScrollView = contentView.scrollView
    }
    
    open var switcherViewHeight: CGFloat {
        return 44
    }
    
    open var titlesInSwitcher: [String] {
        return []
    }
    
    open var badgesInSwitcher: [Int] {
        return []
    }
    
}

extension SegementSlideCustomViewController: SegementSlideSwitcherDataSource {
    
    public var height: CGFloat {
        return switcherViewHeight
    }
    
    public var titles: [String] {
        return titlesInSwitcher
    }
    
}

extension SegementSlideCustomViewController: JXSegmentedViewDelegate {
    
    public func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        contentView.selectItem(at: index, animated: true)
    }
    
}
