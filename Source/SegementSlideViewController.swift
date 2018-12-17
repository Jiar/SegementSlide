//
//  SegementSlideViewController.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SnapKit

public enum BouncesType {
    case parent
    case child
}

open class SegementSlideViewController: UIViewController {
    internal private(set) var collectionView: SegementSlideCollectionView!
    internal private(set) var segementSlideSwitcherView: SegementSlideSwitcherView!
    internal private(set) var segementSlideContentView: SegementSlideContentView!
    internal private(set) var innerHeaderHeight: CGFloat = 0
    internal private(set) var innerHeaderView = UIView()
    private var parentKeyValueObservation: NSKeyValueObservation!
    private var childKeyValueObservation: NSKeyValueObservation?
    private var innerBouncesType: BouncesType = .parent
    private var canParentViewScroll: Bool = true
    private var canChildViewScroll: Bool = false
    
    public var slideScrollView: UIScrollView {
        return collectionView
    }
    
    public var slideSwitcherView: UIView {
        return segementSlideSwitcherView
    }
    public var slideContentView: UIView {
        return segementSlideContentView
    }
    public var headerStickyHeight: CGFloat {
        return innerHeaderHeight
    }
    public var contentViewHeight: CGFloat {
        return view.bounds.height-switcherHeight
    }
    public var currentIndex: Int? {
        return segementSlideContentView.selectedIndex
    }
    public var currentSegementSlideContentViewController: SegementSlideContentScrollViewDelegate? {
        guard let currentIndex = currentIndex else { return nil }
        return segementSlideContentView.segementSlideContentViewController(at: currentIndex)
    }
    
    open var bouncesType: BouncesType {
        return .parent
    }
    
    open func headerHeight() -> CGFloat {
        assert(false, "must override this function")
        return 0
    }
    
    open func headerView() -> UIView {
        assert(false, "must override this function")
        return UIView()
    }
    
    open var switcherType: SwitcherType {
        return .tab
    }
    
    open var switcherHeight: CGFloat {
        return 44
    }
    
    open func titlesInSwitcher() -> [String] {
        assert(false, "must override this function")
        return []
    }
    
    open func showBadgeInSwitcher(at index: Int) -> BadgeType {
        return .none
    }
    
    open var horizontalMarginInSwitcher: CGFloat {
        return 16
    }
    
    open var horizontalSpaceInSwitcher: CGFloat {
        return 22
    }
    
    open var normalTitleFontInSwitcher: UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    
    open var selectedTitleFontInSwitcher: UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    open var normalTitleColorInSwitcher: UIColor {
        return UIColor.gray
    }
    
    open var selectedTitleColorInSwitcher: UIColor {
        return UIColor.darkGray
    }
    
    open var indicatorWidthInSwitcher: CGFloat {
        return 30
    }
    
    open var indicatorHeightInSwitcher: CGFloat {
        return 2
    }
    
    open var indicatorColorInSwitcher: UIColor {
        return UIColor.darkGray
    }
    
    open func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        assert(false, "must override this function")
        return nil
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView, isParent: Bool) {
        
    }
    
    open func didSelectContentViewController(at index: Int) {
        
    }
    
    public func scrollToSlide(at index: Int, animated: Bool) {
        segementSlideSwitcherView.selectSwitcher(at: index, animated: animated)
        segementSlideContentView.scrollToSlide(at: index, animated: animated)
    }
    
    public func contentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        return segementSlideContentView.segementSlideContentViewController(at: index)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        reloadData()
    }
    
    public func reloadData() {
        setupBounces()
        setupHeader()
        setupSwitcher()
        segementSlideSwitcherView.reloadData()
        segementSlideContentView.reloadData()
        collectionView.reloadData()
    }
    
    public func reloadHeader() {
        setupHeader()
        collectionView.reloadData()
    }
    
    public func reloadSwitcher() {
        setupSwitcher()
        segementSlideSwitcherView.reloadData()
    }
    
    public func reloadBadgeInSwitcher() {
        segementSlideSwitcherView.reloadBadges()
    }
    
    public func reloadContent() {
        segementSlideContentView.reloadContents()
    }
    
    deinit {
        #if DEBUG
        print("\(type(of: self)) deinit")
        #endif
    }
    
}

extension SegementSlideViewController {
    
    private func setup() {
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .none
        setupSegementSlideSwitcherView()
        setupSegementSlideContentView()
        setupCollectionView()
    }
    
    private func setupSegementSlideSwitcherView() {
        segementSlideSwitcherView = SegementSlideSwitcherView()
        segementSlideSwitcherView.delegate = self
    }
    
    private func setupSegementSlideContentView() {
        segementSlideContentView = SegementSlideContentView()
        segementSlideContentView.delegate = self
        segementSlideContentView.viewController = self
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        collectionView = SegementSlideCollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SegementSlideHeaderViewCell.self)
        collectionView.register(SegementSlideContentViewCell.self)
        collectionView.register(UICollectionViewCell.self)
        collectionView.register(SegementSlideSwitcherReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.delegate = self
        collectionView.dataSource = self
        if #available(iOS 10.0, *) {
            collectionView.isPrefetchingEnabled = false
        }
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        view.backgroundColor = .white
        parentKeyValueObservation = collectionView.observe(\.contentOffset, options: [.initial, .new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let self = self else { return }
            guard change.newValue != change.oldValue else { return }
            self.parentScrollViewDidScroll(scrollView)
        })
    }
    
    private func setupBounces() {
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
    
    private func setupHeader() {
        innerHeaderHeight = headerHeight()
        innerHeaderView = headerView()
    }
    
    private func setupSwitcher() {
        segementSlideSwitcherView.type = switcherType
        segementSlideSwitcherView.horizontalMargin = horizontalMarginInSwitcher
        segementSlideSwitcherView.horizontalSpace = horizontalSpaceInSwitcher
        segementSlideSwitcherView.normalTitleFont = normalTitleFontInSwitcher
        segementSlideSwitcherView.selectedTitleFont = selectedTitleFontInSwitcher
        segementSlideSwitcherView.normalTitleColor = normalTitleColorInSwitcher
        segementSlideSwitcherView.selectedTitleColor = selectedTitleColorInSwitcher
        segementSlideSwitcherView.indicatorWidth = indicatorWidthInSwitcher
        segementSlideSwitcherView.indicatorHeight = indicatorHeightInSwitcher
        segementSlideSwitcherView.indicatorColor = indicatorColorInSwitcher
    }
    
}

extension SegementSlideViewController: SegementSlideSwitcherViewDelegate {
    
    internal func titlesInSegementSlideSwitcherView() -> [String] {
        return titlesInSwitcher()
    }
    
    internal func segementSwitcherView(_ segementSlideSwitcherView: SegementSlideSwitcherView, didSelectAtIndex index: Int) {
        guard segementSlideContentView.selectedIndex != index else { return }
        segementSlideContentView.scrollToSlide(at: index, animated: true)
    }
    
    internal func segementSwitcherView(_ segementSlideSwitcherView: SegementSlideSwitcherView, showBadgeAtIndex index: Int) -> BadgeType {
        return showBadgeInSwitcher(at: index)
    }
    
}

extension SegementSlideViewController: SegementSlideContentDelegate {
    
    internal var segementSlideContentScrollViewCount: Int {
        return titlesInSwitcher().count
    }
    
    internal func segementSlideContentScrollView(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        return segementSlideContentViewController(at: index)
    }
    
    internal func segementSlideContentView(_ segementSlideContentView: SegementSlideContentView, didSelectAtIndex index: Int) {
        if segementSlideSwitcherView.selectedIndex != index {
            segementSlideSwitcherView.selectSwitcher(at: index, animated: true)
        }
        childKeyValueObservation?.invalidate()
        guard let subViewController = segementSlideContentView.segementSlideContentViewController(at: index) else { return }
        let keyValueObservation = subViewController.scrollView.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let self = self else { return }
            guard change.newValue != change.oldValue else { return }
            self.childScrollViewDidScroll(scrollView)
        })
        childKeyValueObservation = keyValueObservation
        didSelectContentViewController(at: index)
    }
    
}

extension SegementSlideViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            let cell: SegementSlideHeaderViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.config(innerHeaderView, segementSlideContentView: segementSlideContentView)
            return cell
        case 1:
            let cell: SegementSlideContentViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.config(segementSlideContentView)
            return cell
        default:
            break
        }
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        switch section {
        case 0:
            let reusableView: UICollectionReusableView = collectionView.dequeueSupplementaryViewOfKind(kind, forIndexPath: indexPath)
            return reusableView
        case 1:
            let segementSlideSwitcherReusableView: SegementSlideSwitcherReusableView = collectionView.dequeueSupplementaryViewOfKind(kind, forIndexPath: indexPath)
            segementSlideSwitcherReusableView.config(segementSlideSwitcherView)
            return segementSlideSwitcherReusableView
        default:
            let reusableView: UICollectionReusableView = collectionView.dequeueSupplementaryViewOfKind(kind, forIndexPath: indexPath)
            return reusableView
        }
    }
    
}

extension SegementSlideViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        switch section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: innerHeaderHeight)
        case 1:
            return CGSize(width: collectionView.bounds.width, height: contentViewHeight)
        default:
            return CGSize(width: collectionView.bounds.width, height: 0)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 0)
        case 1:
            return CGSize(width: collectionView.bounds.width, height: switcherHeight)
        default:
            return CGSize(width: collectionView.bounds.width, height: 0)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
}

extension SegementSlideViewController {
    
    private func parentScrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScroll(scrollView, isParent: true)
        guard headerStickyHeight != 0 else { return }
        switch innerBouncesType {
        case .parent:
            if !canParentViewScroll {
                collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x, y: headerStickyHeight)
                canChildViewScroll = true
            } else if collectionView.contentOffset.y.keep3 >= headerStickyHeight.keep3 {
                collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x, y: headerStickyHeight.keep3)
                canParentViewScroll = false
                canChildViewScroll = true
            }
        case .child:
            if !canParentViewScroll {
                collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x, y: headerStickyHeight)
                canChildViewScroll = true
            } else if collectionView.contentOffset.y.keep3 >= headerStickyHeight.keep3 {
                collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x, y: headerStickyHeight.keep3)
                canParentViewScroll = false
                canChildViewScroll = true
            } else if collectionView.contentOffset.y <= 0 {
                collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x, y: 0)
                canChildViewScroll = true
            } else {
                canChildViewScroll = false
            }
        }
    }
    
    private func childScrollViewDidScroll(_ childScrollView: UIScrollView) {
        scrollViewDidScroll(childScrollView, isParent: false)
        guard headerStickyHeight != 0 else { return }
        switch innerBouncesType {
        case .parent:
            if !canChildViewScroll {
                childScrollView.contentOffset = CGPoint(x: childScrollView.contentOffset.x, y: 0)
            } else if childScrollView.contentOffset.y <= 0 {
                canChildViewScroll = false
                canParentViewScroll = true
            }
        case .child:
            if !canChildViewScroll {
                childScrollView.contentOffset = CGPoint(x: childScrollView.contentOffset.x, y: 0)
            } else if childScrollView.contentOffset.y <= 0 {
                if collectionView.contentOffset.y <= 0 {
                    canChildViewScroll = true
                }
                canParentViewScroll = true
            } else {
                if collectionView.contentOffset.y > 0 && collectionView.contentOffset.y.keep3 < headerStickyHeight.keep3 {
                    canChildViewScroll = false
                }
            }
        }
    }
    
}

internal class SegementSlideCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
