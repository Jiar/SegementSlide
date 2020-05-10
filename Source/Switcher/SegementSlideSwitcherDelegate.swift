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
    var ssDataSource: SegementSlideSwitcherDataSource? { get set }
    var ssDefaultSelectedIndex: Int? { get set }
    var ssSelectedIndex: Int? { get }
    var ssScrollView: UIScrollView { get }
    
    func reloadData()
    func selectItem(at index: Int, animated: Bool)
}

internal final class SegementSlideSwitcherEmptyView: UIView, SegementSlideSwitcherDelegate {
    weak var ssDataSource: SegementSlideSwitcherDataSource? = nil
    var ssDefaultSelectedIndex: Int? = nil
    var ssSelectedIndex: Int? = nil
    var ssScrollView: UIScrollView = UIScrollView()
    
    func reloadData() {
        
    }
    
    func selectItem(at index: Int, animated: Bool) {
        
    }
}

