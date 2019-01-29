//
//  SegementSlideViewController+setup.swift
//  SegementSlide
//
//  Created by Jiar on 2019/1/16.
//  Copyright © 2019 Jiar. All rights reserved.
//

import UIKit

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
        segementSlideScrollView.constraintToSuperview()
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
        segementSlideHeaderView.translatesAutoresizingMaskIntoConstraints = false
        if edgesForExtendedLayout.contains(.top) {
            segementSlideHeaderView.topConstraint = segementSlideHeaderView.topAnchor.constraint(equalTo: segementSlideScrollView.topAnchor)
        } else {
            segementSlideHeaderView.topConstraint = segementSlideHeaderView.topAnchor.constraint(equalTo: segementSlideScrollView.topAnchor, constant: topLayoutLength)
        }
        segementSlideHeaderView.leadingConstraint = segementSlideHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        segementSlideHeaderView.trailingConstraint = segementSlideHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        if let _ = innerHeaderView, let innerHeaderHeight = innerHeaderHeight {
            segementSlideHeaderView.heightConstraint = segementSlideHeaderView.heightAnchor.constraint(equalToConstant: innerHeaderHeight)
        } else {
            segementSlideHeaderView.heightConstraint = segementSlideHeaderView.heightAnchor.constraint(equalToConstant: 0)
        }
        segementSlideHeaderView.config(innerHeaderView, segementSlideContentView: segementSlideContentView)
        
        segementSlideSwitcherView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = segementSlideSwitcherView.topAnchor.constraint(equalTo: segementSlideHeaderView.bottomAnchor)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        segementSlideSwitcherView.topConstraint = topConstraint
        safeAreaTopConstraint?.isActive = false
        if #available(iOS 11, *) {
            safeAreaTopConstraint = segementSlideSwitcherView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor)
        } else {
            safeAreaTopConstraint = segementSlideSwitcherView.topAnchor.constraint(greaterThanOrEqualTo: topLayoutGuide.bottomAnchor)
        }
        safeAreaTopConstraint?.isActive = true
        segementSlideSwitcherView.leadingConstraint = segementSlideSwitcherView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        segementSlideSwitcherView.trailingConstraint = segementSlideSwitcherView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        segementSlideSwitcherView.heightConstraint = segementSlideSwitcherView.heightAnchor.constraint(equalToConstant: switcherHeight)
        
        segementSlideContentView.translatesAutoresizingMaskIntoConstraints = false
        segementSlideContentView.topConstraint = segementSlideContentView.topAnchor.constraint(equalTo: segementSlideSwitcherView.bottomAnchor)
        segementSlideContentView.leadingConstraint = segementSlideContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        segementSlideContentView.trailingConstraint = segementSlideContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        segementSlideContentView.heightConstraint = segementSlideContentView.heightAnchor.constraint(equalToConstant: contentViewHeight)
        
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
