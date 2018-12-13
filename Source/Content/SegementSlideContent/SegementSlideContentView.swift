//
//  SegementSlideContentView.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

public protocol SegementSlideContentScrollViewDelegate {
    var scrollView: UIScrollView { get }
}

internal protocol SegementSlideContentDelegate: class {
    var segementSlideContentScrollViewCount: Int { get }
    
    func segementSlideContentScrollView(at index: Int) -> SegementSlideContentScrollViewDelegate?
    func segementSlideContentView(_ segementSlideContentView: SegementSlideContentView, didSelectAtIndex index: Int)
}

internal class SegementSlideContentView: UIView {
    
    private var collectionView: UICollectionView!
    private var viewControllers: [Int: SegementSlideContentScrollViewDelegate] = [:]
    
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
        translatesAutoresizingMaskIntoConstraints = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        collectionView.backgroundColor = .clear
        collectionView.register(SegementSlideContentViewChildCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        if #available(iOS 10.0, *) {
            collectionView.isPrefetchingEnabled = false
        }
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        backgroundColor = .clear
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.deactivate(collectionView.constraints)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        guard let selectedIndex = selectedIndex else { return }
        collectionView.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
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
        guard index < delegate?.segementSlideContentScrollViewCount ?? 0 else { return }
        if collectionView.frame != .zero {
            collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: animated)
        }
        setSelectedIndex(index)
    }
    
    internal func reloadContent() {
        viewControllers.removeAll()
        collectionView.reloadData()
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
        setSelectedIndex(index)
    }
    
    private func setSelectedIndex(_ index: Int) {
        guard index != selectedIndex else { return }
        selectedIndex = index
        collectionView.reloadData()
        delegate?.segementSlideContentView(self, didSelectAtIndex: index)
    }
    
}

extension SegementSlideContentView: UICollectionViewDataSource {
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.segementSlideContentScrollViewCount ?? 0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SegementSlideContentViewChildCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        if let viewController = viewController, let childViewController = segementSlideContentViewController(at: indexPath.row) {
            cell.config(viewController: viewController, childViewController: childViewController)
        }
        return cell
    }
    
}

extension SegementSlideContentView: UICollectionViewDelegateFlowLayout {
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollToSlide(at: indexPath.row, animated: true)
    }
    
}
