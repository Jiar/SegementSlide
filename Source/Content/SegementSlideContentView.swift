//
//  SegementSlideContentView.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

@objc
public protocol SegementSlideContentScrollViewDelegate where Self: UIViewController {
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
    internal static let willCleanUpAllReusableViewControllersNotification: NSNotification.Name = NSNotification.Name(rawValue: "willCleanUpAllReusableViewControllersNotification")
    
    public private(set) var scrollView = UIScrollView()
    private var viewControllers: [Int: SegementSlideContentScrollViewDelegate] = [:]
    
    /// you should call `reloadData()` after set this property.
    open var defaultSelectedIndex: Int?
    
    public private(set) var selectedIndex: Int?
    public weak var delegate: SegementSlideContentDelegate?
    public weak var viewController: UIViewController?
    public var isScrollEnabled: Bool {
        get {
            return scrollView.isScrollEnabled
        }
        set {
            scrollView.isScrollEnabled = newValue
        }
    }
    
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
        updateSelectedIndex()
    }
    
    /// remove subViews
    ///
    /// you should set `defaultSelectedIndex` before call this method.
    /// otherwise, no item will be selected.
    /// however, if an item was previously selected, it will be reSelected.
    public func reloadData() {
        cleanUpAllReusableViewControllers()
        updateScrollViewContentSize()
        reloadDataWithSelectedIndex()
    }
    
    /// select one item by index
    public func selectItem(at index: Int, animated: Bool) {
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
        guard !indexFloat.isNaN, indexFloat.isFinite else {
            return
        }
        let index = Int(indexFloat)
        updateSelectedViewController(at: index, animated: true)
    }

}

extension SegementSlideContentView {
    
    private func cleanUpAllReusableViewControllers() {
        NotificationCenter.default.post(name: SegementSlideContentView.willCleanUpAllReusableViewControllersNotification, object: viewController, userInfo: nil)
        for (_, childViewController) in viewControllers {
            childViewController.view.removeAllConstraints()
            childViewController.view.removeFromSuperview()
            childViewController.removeFromParent()
        }
        viewControllers.removeAll()
    }
    
    private func updateScrollViewContentSize() {
        guard let count = delegate?.segementSlideContentScrollViewCount else {
            return
        }
        let contentSize = CGSize(width: CGFloat(count)*scrollView.bounds.width, height: scrollView.bounds.height)
        guard scrollView.contentSize != contentSize else {
            return
        }
        scrollView.contentSize = contentSize
    }
    
    private func layoutViewControllers() {
        for (index, childViewController) in viewControllers {
            guard childViewController.view.superview != nil else {
                continue
            }
            let offsetX = CGFloat(index)*scrollView.bounds.width
            childViewController.view.widthConstraint?.constant = scrollView.bounds.width
            childViewController.view.heightConstraint?.constant = scrollView.bounds.height
            childViewController.view.leadingConstraint?.constant = offsetX
        }
    }
    
    private func reloadDataWithSelectedIndex() {
        guard let index = selectedIndex else {
            return
        }
        selectedIndex = nil
        updateSelectedViewController(at: index, animated: false)
    }
    
    private func updateSelectedIndex() {
        if let index = selectedIndex  {
            updateSelectedViewController(at: index, animated: false)
        } else if let index = defaultSelectedIndex {
            updateSelectedViewController(at: index, animated: false)
        }
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
            return
        }
        guard index != selectedIndex else {
            return
        }
        let count = delegate?.segementSlideContentScrollViewCount ?? 0
        if let selectedIndex = selectedIndex {
            guard selectedIndex >= 0, selectedIndex < count else {
                return
            }
        }
        guard let viewController = viewController,
            index >= 0, index < count else {
            return
        }
        if let lastIndex = selectedIndex, let lastChildViewController = segementSlideContentViewController(at: lastIndex) {
            // last child viewController viewWillDisappear
            lastChildViewController.beginAppearanceTransition(false, animated: animated)
        }
        guard let childViewController = segementSlideContentViewController(at: index) else {
            return
        }
        let isAdded = childViewController.view.superview != nil
        if !isAdded {
            // new child viewController viewDidLoad, viewWillAppear
            viewController.addChild(childViewController)
            scrollView.addSubview(childViewController.view)
        } else {
            // current child viewController viewWillAppear
            childViewController.beginAppearanceTransition(true, animated: animated)
        }
        let offsetX = CGFloat(index)*scrollView.bounds.width
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        childViewController.view.topConstraint = childViewController.view.topAnchor.constraint(equalTo: scrollView.topAnchor)
        childViewController.view.widthConstraint = childViewController.view.widthAnchor.constraint(equalToConstant: scrollView.bounds.width)
        childViewController.view.heightConstraint = childViewController.view.heightAnchor.constraint(equalToConstant: scrollView.bounds.height)
        childViewController.view.leadingConstraint = childViewController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: offsetX)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: scrollView.contentOffset.y), animated: animated)
        if let lastIndex = selectedIndex, let lastChildViewController = segementSlideContentViewController(at: lastIndex) {
            // last child viewController viewDidDisappear
            lastChildViewController.endAppearanceTransition()
        }
        if !isAdded {
            ()
        } else {
            // current child viewController viewDidAppear
            childViewController.endAppearanceTransition()
        }
        selectedIndex = index
        delegate?.segementSlideContentView(self, didSelectAtIndex: index, animated: animated)
    }
    
}
