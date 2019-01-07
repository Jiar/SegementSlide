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
    internal private(set) var segementSlideCollectionView: SegementSlideCollectionView!
    internal private(set) var segementSlideSwitcherView: SegementSlideSwitcherView!
    internal private(set) var segementSlideContentView: SegementSlideContentView!
    internal private(set) var innerHeaderHeight: CGFloat = 0
    internal private(set) var innerHeaderView = UIView()
    private var parentKeyValueObservation: NSKeyValueObservation!
    private var childKeyValueObservation: NSKeyValueObservation?
    private var innerBouncesType: BouncesType = .parent
    private var canParentViewScroll: Bool = true
    private var canChildViewScroll: Bool = false
    private var lastTranslationY: CGFloat = 0
    
    public var slideScrollView: UIScrollView {
        return segementSlideCollectionView
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
        if extendedBottomsafeAreaInset {
            return view.bounds.height-switcherHeight
        } else {
            return view.bounds.height-switcherHeight-bottomLayoutLength
        }
    }
    public var currentIndex: Int? {
        return segementSlideSwitcherView.selectedIndex
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
        return .segement
    }
    
    open var extendedBottomsafeAreaInset: Bool {
        return true
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
    }
    
    public func contentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        return segementSlideContentView.segementSlideContentViewController(at: index)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    public func reloadData() {
        setupBounces()
        setupHeader()
        setupSwitcher()
        segementSlideContentView.reloadData()
        segementSlideSwitcherView.reloadData()
        segementSlideCollectionView.reloadData()
    }
    
    public func reloadHeader() {
        setupHeader()
        segementSlideCollectionView.reloadData()
    }
    
    public func reloadSwitcher() {
        setupSwitcher()
        segementSlideSwitcherView.reloadData()
    }
    
    public func reloadBadgeInSwitcher() {
        segementSlideSwitcherView.reloadBadges()
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
        setupSegementSlideCollectionView()
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
    
    private func setupSegementSlideCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        segementSlideCollectionView = SegementSlideCollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(segementSlideCollectionView)
        segementSlideCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if #available(iOS 11.0, *) {
            segementSlideCollectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        segementSlideCollectionView.backgroundColor = .white
        segementSlideCollectionView.showsHorizontalScrollIndicator = false
        segementSlideCollectionView.showsVerticalScrollIndicator = false
        segementSlideCollectionView.register(SegementSlideHeaderViewCell.self)
        segementSlideCollectionView.register(SegementSlideContentViewCell.self)
        segementSlideCollectionView.register(UICollectionViewCell.self)
        segementSlideCollectionView.register(SegementSlideSwitcherReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        segementSlideCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        segementSlideCollectionView.delegate = self
        segementSlideCollectionView.dataSource = self
        if #available(iOS 10.0, *) {
            segementSlideCollectionView.isPrefetchingEnabled = false
        }
        segementSlideCollectionView.isPagingEnabled = false
        segementSlideCollectionView.isScrollEnabled = true
        view.backgroundColor = .white
        parentKeyValueObservation = segementSlideCollectionView.observe(\.contentOffset, options: [.initial, .new, .old], changeHandler: { [weak self] (scrollView, change) in
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
    
    internal func segementSwitcherView(_ segementSlideSwitcherView: SegementSlideSwitcherView, didSelectAtIndex index: Int, animated: Bool) {
        if segementSlideContentView.selectedIndex != index {
            segementSlideContentView.scrollToSlide(at: index, animated: animated)
        }
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
    
    internal func segementSlideContentView(_ segementSlideContentView: SegementSlideContentView, didSelectAtIndex index: Int, animated: Bool) {
        if segementSlideSwitcherView.selectedIndex != index {
            segementSlideSwitcherView.selectSwitcher(at: index, animated: animated)
        }
        childKeyValueObservation?.invalidate()
        guard let childViewController = segementSlideContentView.segementSlideContentViewController(at: index) else { return }
        let keyValueObservation = childViewController.scrollView.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] (scrollView, change) in
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
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        guard let contentViewController = currentSegementSlideContentViewController else {
            return true
        }
        contentViewController.scrollView.contentOffset.y = 0
        return true
    }
    
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
        let translationY = -scrollView.panGestureRecognizer.translation(in: scrollView).y
        defer {
            lastTranslationY = translationY
        }
        switch innerBouncesType {
        case .parent:
            if !canParentViewScroll {
                segementSlideCollectionView.contentOffset = CGPoint(x: segementSlideCollectionView.contentOffset.x, y: headerStickyHeight)
                canChildViewScroll = true
            } else if segementSlideCollectionView.contentOffset.y.keep3 >= headerStickyHeight.keep3 {
                segementSlideCollectionView.contentOffset = CGPoint(x: segementSlideCollectionView.contentOffset.x, y: headerStickyHeight.keep3)
                canParentViewScroll = false
                canChildViewScroll = true
            }
        case .child:
            if !canParentViewScroll {
                segementSlideCollectionView.contentOffset = CGPoint(x: segementSlideCollectionView.contentOffset.x, y: headerStickyHeight)
                canChildViewScroll = true
            } else if segementSlideCollectionView.contentOffset.y.keep3 >= headerStickyHeight.keep3 {
                segementSlideCollectionView.contentOffset = CGPoint(x: segementSlideCollectionView.contentOffset.x, y: headerStickyHeight.keep3)
                canParentViewScroll = false
                canChildViewScroll = true
            } else if segementSlideCollectionView.contentOffset.y <= 0 {
                segementSlideCollectionView.contentOffset = CGPoint(x: segementSlideCollectionView.contentOffset.x, y: 0)
                canChildViewScroll = true
            } else {
                guard let childScrollView = currentSegementSlideContentViewController?.scrollView else { return }
                if childScrollView.contentOffset.y < 0 {
                    if translationY.keep3 > lastTranslationY.keep3 {
                        segementSlideCollectionView.contentOffset = CGPoint(x: segementSlideCollectionView.contentOffset.x, y: 0)
                        canChildViewScroll = true
                    } else {
                        canChildViewScroll = false
                    }
                } else {
                    canChildViewScroll = false
                }
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
                if segementSlideCollectionView.contentOffset.y <= 0 {
                    canChildViewScroll = true
                }
                canParentViewScroll = true
            } else {
                if segementSlideCollectionView.contentOffset.y > 0 && segementSlideCollectionView.contentOffset.y.keep3 < headerStickyHeight.keep3 {
                    canChildViewScroll = false
                }
            }
        }
    }
    
}

extension SegementSlideViewController {
    
    internal var topLayoutLength: CGFloat {
        let topLayoutLength: CGFloat
        if #available(iOS 11, *) {
            topLayoutLength = view.safeAreaInsets.top
        } else {
            topLayoutLength = topLayoutGuide.length
        }
        return topLayoutLength
    }
    
    internal var bottomLayoutLength: CGFloat {
        let bottomLayoutLength: CGFloat
        if #available(iOS 11, *) {
            bottomLayoutLength = view.safeAreaInsets.bottom
        } else {
            bottomLayoutLength = bottomLayoutGuide.length
        }
        return bottomLayoutLength
    }
    
}

internal class SegementSlideCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
