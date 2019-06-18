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
        setupSegementSlideViews()
        setupSegementSlideScrollView()
        setupSegementSlideHeaderView()
        setupSegementSlideContentView()
        setupSegementSlideSwitcherView()
        observeScrollViewContentOffset()
        observeWillClearAllReusableViewControllersNotification()
    }
    
    private func setupSegementSlideViews() {
        segementSlideHeaderView = SegementSlideHeaderView()
        segementSlideSwitcherView = SegementSlideSwitcherView()
        segementSlideContentView = SegementSlideContentView()
        var gestureRecognizers: [UIGestureRecognizer] = []
        if let gestureRecognizersInScrollView = segementSlideSwitcherView.gestureRecognizersInScrollView {
            gestureRecognizers.append(contentsOf: gestureRecognizersInScrollView)
        }
        if let gestureRecognizersInScrollView = segementSlideContentView.gestureRecognizersInScrollView {
            gestureRecognizers.append(contentsOf: gestureRecognizersInScrollView)
        }
        segementSlideScrollView = SegementSlideScrollView(otherGestureRecognizers: gestureRecognizers)
    }
    
    private func setupSegementSlideHeaderView() {
        segementSlideScrollView.addSubview(segementSlideHeaderView)
    }
    
    private func setupSegementSlideContentView() {
        segementSlideContentView.delegate = self
        segementSlideContentView.viewController = self
        segementSlideScrollView.addSubview(segementSlideContentView)
    }
    
    private func setupSegementSlideSwitcherView() {
        segementSlideSwitcherView.delegate = self
        segementSlideScrollView.addSubview(segementSlideSwitcherView)
    }
    
    private func setupSegementSlideScrollView() {
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
    
    private func observeScrollViewContentOffset() {
        parentKeyValueObservation = segementSlideScrollView.observe(\.contentOffset, options: [.initial, .new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let self = self else { return }
            guard change.newValue != change.oldValue else { return }
            self.parentScrollViewDidScroll(scrollView)
        })
    }
    
    private func observeWillClearAllReusableViewControllersNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(willClearAllReusableViewControllers(_:)), name: SegementSlideContentView.willClearAllReusableViewControllersNotification, object: nil)
    }
    
    @objc private func willClearAllReusableViewControllers(_ notification: Notification) {
        guard let object = notification.object as? SegementSlideViewController, object === self else {
            return
        }
        childKeyValueObservation?.invalidate()
        childKeyValueObservation = nil
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
        innerHeaderView = headerView
    }
    
    internal func setupSwitcher() {
        segementSlideSwitcherView.config = switcherConfig
    }
    
    internal func layoutSegementSlideScrollView() {
        let topLayoutLength: CGFloat
        if edgesForExtendedLayout.contains(.top) {
            topLayoutLength = 0
        } else {
            topLayoutLength = self.topLayoutLength
        }
        
        segementSlideHeaderView.translatesAutoresizingMaskIntoConstraints = false
        if segementSlideHeaderView.topConstraint == nil {
            segementSlideHeaderView.topConstraint = segementSlideHeaderView.topAnchor.constraint(equalTo: segementSlideScrollView.topAnchor, constant: topLayoutLength)
        } else {
            if segementSlideHeaderView.topConstraint?.constant != topLayoutLength {
                segementSlideHeaderView.topConstraint?.constant = topLayoutLength
            }
        }
        if segementSlideHeaderView.leadingConstraint == nil {
            segementSlideHeaderView.leadingConstraint = segementSlideHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        }
        if segementSlideHeaderView.trailingConstraint == nil {
            segementSlideHeaderView.trailingConstraint = segementSlideHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        }
        segementSlideHeaderView.config(innerHeaderView, segementSlideContentView: segementSlideContentView)
        
        segementSlideSwitcherView.translatesAutoresizingMaskIntoConstraints = false
        if segementSlideSwitcherView.topConstraint == nil {
            let topConstraint = segementSlideSwitcherView.topAnchor.constraint(equalTo: segementSlideHeaderView.bottomAnchor)
            topConstraint.priority = UILayoutPriority(rawValue: 999)
            segementSlideSwitcherView.topConstraint = topConstraint
        }
        if safeAreaTopConstraint == nil {
            safeAreaTopConstraint?.isActive = false
            if #available(iOS 11, *) {
                safeAreaTopConstraint = segementSlideSwitcherView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor)
            } else {
                safeAreaTopConstraint = segementSlideSwitcherView.topAnchor.constraint(greaterThanOrEqualTo: topLayoutGuide.bottomAnchor)
            }
            safeAreaTopConstraint?.isActive = true
        }
        if segementSlideSwitcherView.leadingConstraint == nil {
            segementSlideSwitcherView.leadingConstraint = segementSlideSwitcherView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        }
        if segementSlideSwitcherView.trailingConstraint == nil {
            segementSlideSwitcherView.trailingConstraint = segementSlideSwitcherView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        }
        if segementSlideSwitcherView.heightConstraint == nil {
            segementSlideSwitcherView.heightConstraint = segementSlideSwitcherView.heightAnchor.constraint(equalToConstant: switcherHeight)
        } else {
            if segementSlideSwitcherView.heightConstraint?.constant != switcherHeight {
                segementSlideSwitcherView.heightConstraint?.constant = switcherHeight
            }
        }
        
        segementSlideContentView.translatesAutoresizingMaskIntoConstraints = false
        if segementSlideContentView.topConstraint == nil {
            segementSlideContentView.topConstraint = segementSlideContentView.topAnchor.constraint(equalTo: segementSlideSwitcherView.bottomAnchor)
        }
        if segementSlideContentView.leadingConstraint == nil {
            segementSlideContentView.leadingConstraint = segementSlideContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        }
        if segementSlideContentView.trailingConstraint == nil {
            segementSlideContentView.trailingConstraint = segementSlideContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        }
        if segementSlideContentView.bottomConstraint == nil {
            segementSlideContentView.bottomConstraint = segementSlideContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }
        
        segementSlideHeaderView.layer.zPosition = -3
        segementSlideContentView.layer.zPosition = -2
        segementSlideSwitcherView.layer.zPosition = -1
        
        segementSlideHeaderView.layoutIfNeeded()
        
        let innerHeaderHeight = segementSlideHeaderView.frame.height
        let contentSize = CGSize(
            width: view.bounds.width,
            height: topLayoutLength + innerHeaderHeight + switcherHeight + contentViewHeight + 1
        )
        if segementSlideScrollView.contentSize != contentSize {
            segementSlideScrollView.contentSize = contentSize
        }
    }
    
    internal func resetChildViewControllerContentOffsetY() {
        guard segementSlideScrollView.contentOffset.y < headerStickyHeight else {
            return
        }
        let collection = waitTobeResetContentOffsetY
        for index in collection {
            guard index != currentIndex,
                let scrollView = dequeueReusableViewController(at: index)?.scrollView else {
                continue
            }
            waitTobeResetContentOffsetY.remove(index)
            scrollView.contentOffset.y = 0
        }
    }
    
}
