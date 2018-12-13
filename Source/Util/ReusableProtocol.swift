//
//  ReusableProtocol.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

internal protocol ReusableView: NSObjectProtocol {
    static var cellIdentifier: String {get}
}

internal extension ReusableView where Self: UIView {
    internal static var cellIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UICollectionReusableView: ReusableView {}

internal extension UICollectionView {
    
    internal func register<T: UICollectionViewCell>(_: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.cellIdentifier)
    }
    
    internal func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withReuseIdentifier: T.cellIdentifier, for: indexPath)
        return cell as! T
    }
    
    internal func register<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind kind: String) {
        self.register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.cellIdentifier)
    }
    
    internal func dequeueSupplementaryViewOfKind<T: UICollectionReusableView>(_ elementKind: String, forIndexPath: IndexPath) -> T {
        let view = self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.cellIdentifier, for: forIndexPath) as! T
        return view
    }
}
