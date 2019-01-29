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
        layoutViewControllers()
        recoverInitSelectedIndex()
    }
    
    /// remove subViews
    ///
    /// you should call `scrollToSlide(at index: Int, animated: Bool)` after call the method.
    /// otherwise, none of them will be selected.
    /// However, if an item was previously selected, it will be reSelected.
    public func reloadData() {
        for (_, value) in viewControllers {
            let childViewController = value as! UIViewController
            childViewController.view.removeFromSuperview()
            childViewController.removeFromParent()
        }
        viewControllers.removeAll()
        guard let selectedIndex = selectedIndex else { return }
        updateSelectedViewController(at: selectedIndex, animated: false)
    }
    
    /// select one item by index
    public func scrollToSlide(at index: Int, animated: Bool) {
        updateSelectedViewController(at: index, animated: animated)
    }
    
    /// reuse the `SegementSlideContentScrollViewDelegate`
    public func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        if let childViewController = viewControllers[index] {
            return childViewController
        } else if let childViewController = delegate?.segementSlideContentScrollView(at: index) {
            viewControllers[index] = childViewController
            return childViewController
        }
        return nil
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
    
    private func layoutViewControllers() {
        for (index, value) in viewControllers {
            let childViewController = value as! UIViewController
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
        let contentSize = CGSize(width: CGFloat(count)*scrollView.bounds.width, height: scrollView.bounds.height)
        if scrollView.contentSize != contentSize {
            scrollView.contentSize = contentSize
        }
        let childViewController = segementSlideContentViewController(at: index) as! UIViewController
        if childViewController.view.superview == nil {
            viewController.addChild(childViewController)
            scrollView.addSubview(childViewController.view)
        }
        let offsetX = CGFloat(index)*scrollView.bounds.width
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        childViewController.view.topConstraint = childViewController.view.topAnchor.constraint(equalTo: scrollView.topAnchor)
        childViewController.view.widthConstraint = childViewController.view.widthAnchor.constraint(equalToConstant: scrollView.bounds.width)
        childViewController.view.heightConstraint = childViewController.view.heightAnchor.constraint(equalToConstant: scrollView.bounds.height)
        childViewController.view.leadingConstraint = childViewController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: offsetX)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: scrollView.contentOffset.y), animated: animated)
        guard index != selectedIndex else { return }
        selectedIndex = index
        delegate?.segementSlideContentView(self, didSelectAtIndex: index, animated: animated)
    }
    
}
