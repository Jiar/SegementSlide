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
        headerView = SegementSlideHeaderView()
        switcherView = segementSlideSwitcherView()
        contentView = SegementSlideContentView()
        var gestureRecognizers: [UIGestureRecognizer] = []
        if let gestureRecognizersInScrollView = switcherView.ssScrollView.gestureRecognizers {
            gestureRecognizers.append(contentsOf: gestureRecognizersInScrollView)
        }
        if let gestureRecognizersInScrollView = contentView.scrollView.gestureRecognizers {
            gestureRecognizers.append(contentsOf: gestureRecognizersInScrollView)
        }
        scrollView = SegementSlideScrollView(otherGestureRecognizers: gestureRecognizers)
    }
    
    private func setupSegementSlideHeaderView() {
        scrollView.addSubview(headerView)
    }
    
    private func setupSegementSlideContentView() {
        contentView.delegate = self
        contentView.viewController = self
        scrollView.addSubview(contentView)
    }
    
    internal func setupSegementSlideSwitcherView() {
        scrollView.addSubview(switcherView)
    }
    
    private func setupSegementSlideScrollView() {
        view.addSubview(scrollView)
        scrollView.constraintToSuperview()
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        scrollView.backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = false
        scrollView.isScrollEnabled = true
        scrollView.delegate = self
    }
    
    private func observeScrollViewContentOffset() {
        parentKeyValueObservation = scrollView.observe(\.contentOffset, options: [.initial, .new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let self = self else {
                return
            }
            guard change.newValue != change.oldValue else {
                return
            }
            self.parentScrollViewDidScroll(scrollView)
        })
    }
    
    private func observeWillClearAllReusableViewControllersNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(willClearAllReusableViewControllers(_:)), name: SegementSlideContentView.willClearAllReusableViewControllersNotification, object: nil)
    }
    
    @objc
    private func willClearAllReusableViewControllers(_ notification: Notification) {
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
    
    internal func layoutSegementSlideScrollView() {
        let topLayoutLength: CGFloat
        if edgesForExtendedLayout.contains(.top) {
            topLayoutLength = 0
        } else {
            topLayoutLength = self.topLayoutLength
        }
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        if headerView.topConstraint == nil {
            headerView.topConstraint = headerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: topLayoutLength)
        } else {
            if headerView.topConstraint?.constant != topLayoutLength {
                headerView.topConstraint?.constant = topLayoutLength
            }
        }
        if headerView.leadingConstraint == nil {
            headerView.leadingConstraint = headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        }
        if headerView.trailingConstraint == nil {
            headerView.trailingConstraint = headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        }
        headerView.config(innerHeaderView, contentView: contentView)
        
        switcherView.translatesAutoresizingMaskIntoConstraints = false
        if switcherView.topConstraint == nil {
            let topConstraint = switcherView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
            topConstraint.priority = UILayoutPriority(rawValue: 999)
            switcherView.topConstraint = topConstraint
        }
        if safeAreaTopConstraint == nil {
            safeAreaTopConstraint?.isActive = false
            if #available(iOS 11, *) {
                safeAreaTopConstraint = switcherView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor)
            } else {
                safeAreaTopConstraint = switcherView.topAnchor.constraint(greaterThanOrEqualTo: topLayoutGuide.bottomAnchor)
            }
            safeAreaTopConstraint?.isActive = true
        }
        if switcherView.leadingConstraint == nil {
            switcherView.leadingConstraint = switcherView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        }
        if switcherView.trailingConstraint == nil {
            switcherView.trailingConstraint = switcherView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        }
        if switcherView.heightConstraint == nil {
            switcherView.heightConstraint = switcherView.heightAnchor.constraint(equalToConstant: switcherHeight)
        } else {
            if switcherView.heightConstraint?.constant != switcherHeight {
                switcherView.heightConstraint?.constant = switcherHeight
            }
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        if contentView.topConstraint == nil {
            contentView.topConstraint = contentView.topAnchor.constraint(equalTo: switcherView.bottomAnchor)
        }
        if contentView.leadingConstraint == nil {
            contentView.leadingConstraint = contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        }
        if contentView.trailingConstraint == nil {
            contentView.trailingConstraint = contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        }
        if contentView.bottomConstraint == nil {
            contentView.bottomConstraint = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }
        
        headerView.layer.zPosition = -3
        contentView.layer.zPosition = -2
        switcherView.layer.zPosition = -1
        
        headerView.layoutIfNeeded()
        
        let innerHeaderHeight = headerView.frame.height
        let contentSize = CGSize(width: view.bounds.width, height: topLayoutLength+innerHeaderHeight+switcherHeight+contentViewHeight+1)
        if scrollView.contentSize != contentSize {
            scrollView.contentSize = contentSize
        }
    }
    
    internal func resetChildViewControllerContentOffsetY() {
        guard scrollView.contentOffset.y < headerStickyHeight else {
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
