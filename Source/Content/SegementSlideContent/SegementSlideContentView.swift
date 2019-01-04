//
//  SegementSlideContentView.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SnapKit

public protocol SegementSlideContentScrollViewDelegate {
    var scrollView: UIScrollView { get }
}

internal protocol SegementSlideContentDelegate: class {
    var segementSlideContentScrollViewCount: Int { get }
    
    func segementSlideContentScrollView(at index: Int) -> SegementSlideContentScrollViewDelegate?
    func segementSlideContentView(_ segementSlideContentView: SegementSlideContentView, didSelectAtIndex index: Int, animated: Bool)
}

internal class SegementSlideContentView: UIView {
    
    private let scrollView = UIScrollView()
    private var viewControllers: [Int: SegementSlideContentScrollViewDelegate] = [:]
    
    private var initSelectedIndex: Int?
    internal private(set) var selectedIndex: Int?
    internal weak var delegate: SegementSlideContentDelegate?
    internal weak var viewController: SegementSlideViewController?
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        backgroundColor = .white
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        guard scrollView.frame != .zero else { return }
        guard let count = delegate?.segementSlideContentScrollViewCount else { return }
        scrollView.contentSize = CGSize(width: CGFloat(count)*bounds.width, height: bounds.height)
        if let initSelectedIndex = initSelectedIndex {
            self.initSelectedIndex = nil
            updateSelectedViewController(at: initSelectedIndex, animated: false)
        }
    }
    
    internal func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        if let subViewController = viewControllers[index] {
            return subViewController
        } else if let subViewController = delegate?.segementSlideContentScrollView(at: index) {
            viewControllers[index] = subViewController
            return subViewController
        }
        return nil
    }
    
    internal func scrollToSlide(at index: Int, animated: Bool) {
        updateSelectedViewController(at: index, animated: animated)
    }
    
    internal func reloadData() {
        for (_, value) in viewControllers {
            guard let subViewController = value as? UIViewController else {
                continue
            }
            subViewController.view.removeFromSuperview()
            subViewController.removeFromParent()
        }
        viewControllers.removeAll()
        guard let selectedIndex = selectedIndex else { return }
        updateSelectedViewController(at: selectedIndex, animated: false)
    }
    
}

extension SegementSlideContentView: UIScrollViewDelegate {

    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate { return }
        scrollViewDidEndScroll(scrollView)
    }

    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll(scrollView)
    }

    private func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        let indexFloat = scrollView.contentOffset.x/scrollView.bounds.width
        guard !indexFloat.isNaN, indexFloat.isFinite else { return }
        let index = Int(indexFloat)
        updateSelectedViewController(at: index, animated: true)
    }
    
    private func updateSelectedViewController(at index: Int, animated: Bool) {
        guard scrollView.frame != .zero else {
            initSelectedIndex = index
            return
        }
        guard let viewController = viewController,
            let count = delegate?.segementSlideContentScrollViewCount,
            count != 0, index >= 0, index < count,
            let subViewController = segementSlideContentViewController(at: index) as? UIViewController else {
                return
        }
        viewController.addChild(subViewController)
        scrollView.addSubview(subViewController.view)
        let offsetX = CGFloat(index)*scrollView.bounds.width
        subViewController.view.snp.remakeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.size.equalTo(scrollView.bounds.size)
            make.leading.equalTo(scrollView.snp.leading).offset(offsetX)
        }
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
        }
        guard index != selectedIndex else { return }
        selectedIndex = index
        delegate?.segementSlideContentView(self, didSelectAtIndex: index, animated: animated)
    }

}
