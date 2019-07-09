//
//  SegementSlideContentView.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

@objc public protocol SegementSlideContentScrollViewDelegate where Self: UIViewController {
    /// must implement this variable, when use class `SegementSlideViewController` or it's subClass.
    /// you can ignore this variable, when you use `SegementSlideContentView` alone.
    @objc optional var scrollView: UIScrollView { get }
}

public protocol SegementSlideContentDelegate: class {
    var segementSlideContentScrollViewCount: Int { get }
    
    func segementSlideContentScrollView(at index: Int) -> SegementSlideContentScrollViewDelegate?
    func segementSlideContentView(_ segementSlideContentView: SegementSlideContentView, didSelectAtIndex index: Int, animated: Bool)
}

public class SegementSlideContentView: UIView {
    internal static let willClearAllReusableViewControllersNotification: NSNotification.Name = NSNotification.Name(rawValue: "willClearAllReusableViewControllersNotification")
    
    private let scrollView = UIScrollView()
    private var viewControllers: [Int: SegementSlideContentScrollViewDelegate] = [:]
    private var initSelectedIndex: Int?
    
    public private(set) var selectedIndex: Int?
    public weak var delegate: SegementSlideContentDelegate?
    public weak var viewController: UIViewController?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(scrollView)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.constraintToSuperview()
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        backgroundColor = .white
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateScrollViewContentSize()
        layoutViewControllers()
        recoverInitSelectedIndex()
        updateSelectedIndex()
    }
    
    /// remove subViews
    ///
    /// you should call `scrollToSlide(at index: Int, animated: Bool)` after call the method.
    /// otherwise, none of them will be selected.
    /// However, if an item was previously selected, it will be reSelected.
    public func reloadData() {
        clearAllReusableViewControllers()
        updateScrollViewContentSize()
        updateSelectedIndex()
    }
    
    /// select one item by index
    public func scrollToSlide(at index: Int, animated: Bool) {
        updateSelectedViewController(at: index, animated: animated)
    }
    
    /// reuse the `SegementSlideContentScrollViewDelegate`
    public func dequeueReusableViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        if let childViewController = viewControllers[index] {
            return childViewController
        } else {
            return nil
        }
    }
    
}

extension SegementSlideContentView: UIScrollViewDelegate {

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate { return }
        scrollViewDidEndScroll(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll(scrollView)
    }

    private func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        let indexFloat = scrollView.contentOffset.x/scrollView.bounds.width
        guard !indexFloat.isNaN, indexFloat.isFinite else { return }
        let index = Int(indexFloat)
        updateSelectedViewController(at: index, animated: true)
    }

}

extension SegementSlideContentView {
    
    private func updateScrollViewContentSize() {
        guard let count = delegate?.segementSlideContentScrollViewCount else { return }
        let contentSize = CGSize(width: CGFloat(count)*scrollView.bounds.width, height: scrollView.bounds.height)
        guard scrollView.contentSize != contentSize else { return }
        scrollView.contentSize = contentSize
    }
    
    private func clearAllReusableViewControllers() {
        NotificationCenter.default.post(name: SegementSlideContentView.willClearAllReusableViewControllersNotification, object: nil, userInfo: nil)
        for (_, value) in viewControllers {
            guard let childViewController = value as? UIViewController else { continue }
            childViewController.view.removeAllConstraints()
            childViewController.view.removeFromSuperview()
            childViewController.removeFromParent()
        }
        viewControllers.removeAll()
    }
    
    private func layoutViewControllers() {
        for (index, value) in viewControllers {
            guard let childViewController = value as? UIViewController else { continue }
            guard childViewController.view.superview != nil else { continue }
            let offsetX = CGFloat(index)*scrollView.bounds.width
            childViewController.view.widthConstraint?.constant = scrollView.bounds.width
            childViewController.view.heightConstraint?.constant = scrollView.bounds.height
            childViewController.view.leadingConstraint?.constant = offsetX
        }
    }
    
    private func recoverInitSelectedIndex() {
        guard let initSelectedIndex = initSelectedIndex else { return }
        self.initSelectedIndex = nil
        updateSelectedViewController(at: initSelectedIndex, animated: false)
    }
    
    private func updateSelectedIndex() {
        guard let selectedIndex = selectedIndex else { return }
        updateSelectedViewController(at: selectedIndex, animated: false)
    }
    
    private func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        if let childViewController = dequeueReusableViewController(at: index) {
            return childViewController
        } else if let childViewController = delegate?.segementSlideContentScrollView(at: index) {
            viewControllers[index] = childViewController
            return childViewController
        }
        return nil
    }
    
    private func updateSelectedViewController(at index: Int, animated: Bool) {
        guard scrollView.frame != .zero else {
            initSelectedIndex = index
            return
        }
        guard let viewController = viewController,
            let count = delegate?.segementSlideContentScrollViewCount,
            count != 0, index >= 0, index < count else {
            return
        }
        if index != selectedIndex, let lastIndex = selectedIndex, let lastChildViewController = segementSlideContentViewController(at: lastIndex) as? UIViewController {
            // last child viewController viewWillDisappear
            lastChildViewController.beginAppearanceTransition(false, animated: animated)
        }
        guard let childViewController = segementSlideContentViewController(at: index) as? UIViewController else { return }
        let isAdded = childViewController.view.superview != nil
        if !isAdded {
            // new child viewController viewDidLoad, viewWillAppear
            viewController.addChild(childViewController)
            scrollView.addSubview(childViewController.view)
        } else {
            if index != selectedIndex {
                // current child viewController viewWillAppear
                childViewController.beginAppearanceTransition(true, animated: animated)
            }
        }
        let offsetX = CGFloat(index)*scrollView.bounds.width
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        childViewController.view.topConstraint = childViewController.view.topAnchor.constraint(equalTo: scrollView.topAnchor)
        childViewController.view.widthConstraint = childViewController.view.widthAnchor.constraint(equalToConstant: scrollView.bounds.width)
        childViewController.view.heightConstraint = childViewController.view.heightAnchor.constraint(equalToConstant: scrollView.bounds.height)
        childViewController.view.leadingConstraint = childViewController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: offsetX)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: scrollView.contentOffset.y), animated: animated)
        if index != selectedIndex, let lastIndex = selectedIndex, let lastChildViewController = segementSlideContentViewController(at: lastIndex) as? UIViewController {
            // last child viewController viewDidDisappear
            lastChildViewController.endAppearanceTransition()
        }
        if !isAdded {
            ()
        } else {
            if index != selectedIndex {
                // current child viewController viewDidAppear
                childViewController.endAppearanceTransition()
            }
        }
        selectedIndex = index
        delegate?.segementSlideContentView(self, didSelectAtIndex: index, animated: animated)
    }
    
}
