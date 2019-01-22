//
//  SegementSlideViewController+setup.swift
//  SegementSlide
//
//  Created by Jiar on 2019/1/16.
//  Copyright © 2019 Jiar. All rights reserved.
//

import UIKit
import SnapKit

extension SegementSlideViewController {
    
    internal func setup() {
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = []
        setupSegementSlideScrollView()
        setupSegementSlideHeaderView()
        setupSegementSlideContentView()
        setupSegementSlideSwitcherView()
        observeScrollViewContentOffset()
    }
    
    internal func setupSegementSlideHeaderView() {
        segementSlideHeaderView = SegementSlideHeaderView()
        segementSlideScrollView.addSubview(segementSlideHeaderView)
    }
    
    internal func setupSegementSlideContentView() {
        segementSlideContentView = SegementSlideContentView()
        segementSlideContentView.delegate = self
        segementSlideContentView.viewController = self
        segementSlideScrollView.addSubview(segementSlideContentView)
    }
    
    internal func setupSegementSlideSwitcherView() {
        segementSlideSwitcherView = SegementSlideSwitcherView()
        segementSlideSwitcherView.delegate = self
        segementSlideScrollView.addSubview(segementSlideSwitcherView)
    }
    
    internal func setupSegementSlideScrollView() {
        segementSlideScrollView = SegementSlideScrollView()
        view.addSubview(segementSlideScrollView)
        segementSlideScrollView.snp.remakeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        if #available(iOS 11.0, *) {
            segementSlideScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        segementSlideScrollView.backgroundColor = .white
        segementSlideScrollView.showsHorizontalScrollIndicator = false
        segementSlideScrollView.showsVerticalScrollIndicator = false
        segementSlideScrollView.isPagingEnabled = false
        segementSlideScrollView.isScrollEnabled = true
        segementSlideScrollView.delegate = self
    }
    
    internal func observeScrollViewContentOffset() {
        parentKeyValueObservation = segementSlideScrollView.observe(\.contentOffset, options: [.initial, .new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let self = self else { return }
            guard change.newValue != change.oldValue else { return }
            self.parentScrollViewDidScroll(scrollView)
        })
    }
    
    internal func setupBounces() {
        innerBouncesType = bouncesType
        switch innerBouncesType {
        case .parent:
            canParentViewScroll = true
            canChildViewScroll = false
        case .child:
            canParentViewScroll = true
            canChildViewScroll = true
        }
    }
    
    internal func setupHeader() {
        innerHeaderHeight = headerHeight?.rounded(.up)
        innerHeaderView = headerView
    }
    
    internal func setupSwitcher() {
        segementSlideSwitcherView.config = switcherConfig
    }
    
    internal func layoutSegementSlideScrollView() {
        segementSlideHeaderView.snp.remakeConstraints { make in
            if edgesForExtendedLayout.contains(.top) {
                make.top.equalTo(segementSlideScrollView.snp.top).offset(0)
            } else {
                make.top.equalTo(segementSlideScrollView.snp.top).offset(topLayoutLength)
            }
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            if let _ = innerHeaderView, let innerHeaderHeight = innerHeaderHeight {
                make.height.equalTo(innerHeaderHeight)
            } else {
                make.height.equalTo(0)
            }
        }
        segementSlideHeaderView.config(innerHeaderView, segementSlideContentView: segementSlideContentView)
        segementSlideSwitcherView.snp.remakeConstraints { make in
            if let _ = innerHeaderView {
                make.top.equalTo(segementSlideHeaderView.snp.bottom).priority(999)
            } else {
                if edgesForExtendedLayout.contains(.top) {
                    make.top.equalTo(segementSlideScrollView.snp.top).offset(0).priority(999)
                } else {
                    make.top.equalTo(segementSlideScrollView.snp.top).offset(topLayoutLength).priority(999)
                }
            }
            if #available(iOS 11, *) {
                make.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.greaterThanOrEqualTo(topLayoutGuide.snp.bottom)
            }
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(switcherHeight)
        }
        segementSlideContentView.snp.remakeConstraints { make in
            make.top.equalTo(segementSlideSwitcherView.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(contentViewHeight)
        }
        segementSlideHeaderView.layer.zPosition = -3
        segementSlideContentView.layer.zPosition = -2
        segementSlideSwitcherView.layer.zPosition = -1
        if edgesForExtendedLayout.contains(.top) {
            segementSlideScrollView.contentSize = CGSize(width: view.bounds.width, height: (innerHeaderHeight ?? 0)+switcherHeight+contentViewHeight+1)
        } else {
            segementSlideScrollView.contentSize = CGSize(width: view.bounds.width, height: topLayoutLength+(innerHeaderHeight ?? 0)+switcherHeight+contentViewHeight+1)
        }
    }
    
}
