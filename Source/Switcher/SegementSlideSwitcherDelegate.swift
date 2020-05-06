//
//  SegementSlideSwitcherDelegate.swift
//  SegementSlide
//
//  Created by Jiar on 2020/5/5.
//

import UIKit

public protocol SegementSlideSwitcherDataSource: class {
    var height: CGFloat { get }
    var titles: [String] { get }
}

public protocol SegementSlideSwitcherDelegate: UIView {
    var dataSource: SegementSlideSwitcherDataSource? { get set }
    var scrollView: UIScrollView { get }
    var selectedIndex: Int? { get }
    
    func reloadData()
    func reloadBadges()
    func selectSwitcher(at index: Int, animated: Bool)
}

internal final class SegementSlideSwitcherEmptyView: UIView, SegementSlideSwitcherDelegate {
    weak var dataSource: SegementSlideSwitcherDataSource? = nil
    var scrollView: UIScrollView = UIScrollView()
    var selectedIndex: Int? = nil
    
    func reloadData() {
        
    }
    
    func reloadBadges() {
        
    }
    
    func selectSwitcher(at index: Int, animated: Bool) {
        
    }
}

