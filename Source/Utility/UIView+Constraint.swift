//
//  UIView+Constraint.swift
//  SegementSlide
//
//  Created by Jiar on 2019/1/29.
//

import UIKit

private var topConstraintKey: Void?
private var bottomConstraintKey: Void?
private var leadingConstraintKey: Void?
private var trailingConstraintKey: Void?
private var widthConstraintKey: Void?
private var heightConstraintKey: Void?

internal extension UIView {
    
    var topConstraint: NSLayoutConstraint? {
        get {
            if let value = objc_getAssociatedObject(self, &topConstraintKey) as? NSLayoutConstraint {
                return value
            } else {
                return nil
            }
        }
        set {
            topConstraint?.isActive = false
            if let newValue = newValue {
                newValue.isActive = true
            }
            objc_setAssociatedObject(self, &topConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var bottomConstraint: NSLayoutConstraint? {
        get {
            if let value = objc_getAssociatedObject(self, &bottomConstraintKey) as? NSLayoutConstraint {
                return value
            } else {
                return nil
            }
        }
        set {
            bottomConstraint?.isActive = false
            if let newValue = newValue {
                newValue.isActive = true
            }
            objc_setAssociatedObject(self, &bottomConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var leadingConstraint: NSLayoutConstraint? {
        get {
            if let value = objc_getAssociatedObject(self, &leadingConstraintKey) as? NSLayoutConstraint {
                return value
            } else {
                return nil
            }
        }
        set {
            leadingConstraint?.isActive = false
            if let newValue = newValue {
                newValue.isActive = true
            }
            objc_setAssociatedObject(self, &leadingConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var trailingConstraint: NSLayoutConstraint? {
        get {
            if let value = objc_getAssociatedObject(self, &trailingConstraintKey) as? NSLayoutConstraint {
                return value
            } else {
                return nil
            }
        }
        set {
            trailingConstraint?.isActive = false
            if let newValue = newValue {
                newValue.isActive = true
            }
            objc_setAssociatedObject(self, &trailingConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var widthConstraint: NSLayoutConstraint? {
        get {
            if let value = objc_getAssociatedObject(self, &widthConstraintKey) as? NSLayoutConstraint {
                return value
            } else {
                return nil
            }
        }
        set {
            widthConstraint?.isActive = false
            if let newValue = newValue {
                newValue.isActive = true
            }
            objc_setAssociatedObject(self, &widthConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            if let value = objc_getAssociatedObject(self, &heightConstraintKey) as? NSLayoutConstraint {
                return value
            } else {
                return nil
            }
        }
        set {
            heightConstraint?.isActive = false
            if let newValue = newValue {
                newValue.isActive = true
            }
            objc_setAssociatedObject(self, &heightConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

internal extension UIView {
    
    func constraintToSuperview() {
        guard let superview = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        topConstraint = topAnchor.constraint(equalTo: superview.topAnchor)
        bottomConstraint = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        leadingConstraint = leadingAnchor.constraint(equalTo: superview.leadingAnchor)
        trailingConstraint = trailingAnchor.constraint(equalTo: superview.trailingAnchor)
    }
    
    func removeAllConstraints() {
        topConstraint = nil
        bottomConstraint = nil
        leadingConstraint = nil
        trailingConstraint = nil
        widthConstraint = nil
        heightConstraint = nil
    }
    
}
