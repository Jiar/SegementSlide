//
//  BadgeView.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

public enum BadgeType {
    case none
    case point
    case count(_ count: Int)
    
    /// - height:
    /// It will change the value of the `height` parameter in `Badge`.
    /// Use the value of the `height` parameter in `Badge`, if the `height` variable is nil.
    ///
    /// - cornerRadius:
    /// Use half the value of the `height` parameter in `Badge`, if the `cornerRadius` variable is nil
    case custom(_ attributedString: NSAttributedString, _ height: CGFloat?, _ cornerRadius: CGFloat?)
}

private final class BadgeView: UILabel {
    
    fileprivate override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let superview = superview {
            return superview
        } else {
            return super.hitTest(point, with: event)
        }
    }
    
}

private var badgeKey: Void?

internal extension UIView {
    
    var badge: Badge {
        get {
            let badge: Badge
            if let value = objc_getAssociatedObject(self, &badgeKey) as? Badge {
                badge = value
            } else {
                badge = Badge(self)
                objc_setAssociatedObject(self, &badgeKey, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return badge
        }
    }
    
}

internal final class Badge {
    
    private let badgeView: BadgeView
    
    private var centerXConstraint: NSLayoutConstraint?
    private var centerYConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    
    internal init(_ superView: UIView) {
        badgeView = BadgeView()
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeView.isEnabled = true
        badgeView.isUserInteractionEnabled = true
        badgeView.clipsToBounds = true
        badgeView.layer.masksToBounds = true
        badgeView.textAlignment = .center
        badgeView.textColor = .white
        badgeView.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        superView.addSubview(badgeView)
    }
    
    /// font for the `.count` type
    internal var font: UIFont = UIFont.systemFont(ofSize: 10, weight: .regular) {
        didSet {
            if case .count = type {
                badgeView.font = font
            }
        }
    }
    
    /// Badge's height, Badge's cornerRadius is half of the value
    internal var height: CGFloat = 9 {
        didSet {
            updateHeight()
        }
    }
    
    /// Badge's center position relative to the parent view's center position displacement
    /// A positive x means moving to the right
    /// A positive y means moving to the bottom
    internal var offset: CGPoint = .zero {
        didSet {
            remakeConstraints()
        }
    }
    
    /// the type of `Badge`
    internal var type: BadgeType = .none {
        didSet {
            switch type {
            case .none, .point:
                badgeView.isHidden = false
                badgeView.backgroundColor = .red
                badgeView.numberOfLines = 1
                badgeView.text = nil
                badgeView.attributedText = nil
            case .count(let count):
                badgeView.isHidden = count == 0
                badgeView.backgroundColor = .red
                badgeView.numberOfLines = 1
                let string: String
                if count > 99 {
                    string = "99+"
                } else {
                    string = "\(count)"
                }
                badgeView.attributedText = nil
                badgeView.text = string
            case let .custom(attributedString, height, _):
                badgeView.isHidden = false
                badgeView.backgroundColor = .clear
                badgeView.numberOfLines = 0
                if let height = height {
                    self.height = height
                }
                badgeView.text = nil
                badgeView.attributedText = attributedString
            }
            remakeConstraints()
        }
    }
    
    private func remakeConstraints() {
        guard let _ = badgeView.superview else {
            return
        }
        updateCenterXConstraint()
        updateCenterYConstraint()
        updateHeightConstraint()
        updateWidthConstraint()
        updateCornerRadius()
    }
    
    private func updateHeight() {
        updateHeightConstraint()
        updateWidthConstraint()
        updateCornerRadius()
    }
    
    private func updateCenterXConstraint() {
        guard let superView = badgeView.superview else {
            return
        }
        if let centerXConstraint = centerXConstraint {
            centerXConstraint.constant = offset.x
        } else {
            centerXConstraint = badgeView.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: offset.x)
            centerXConstraint?.isActive = true
        }
    }
    
    private func updateCenterYConstraint() {
        guard let superView = badgeView.superview else {
            return
        }
        if let centerYConstraint = centerYConstraint {
            centerYConstraint.constant = offset.y
        } else {
            centerYConstraint = badgeView.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: offset.y)
            centerYConstraint?.isActive = true
        }
    }
    
    private func updateHeightConstraint() {
        if let heightConstraint = heightConstraint {
            heightConstraint.constant = height
        } else {
            heightConstraint = badgeView.heightAnchor.constraint(equalToConstant: height)
            heightConstraint?.isActive = true
        }
    }
    
    private func updateWidthConstraint() {
        let width: CGFloat?
        switch type {
        case .none:
            width = 0
        case .point:
            width = height
        case .count(let count):
            if count > 0, let string = badgeView.text {
                if count >= 10 {
                    width = string.boundingWidth(with: badgeView.font)+(height-"0".boundingWidth(with: badgeView.font))
                } else {
                    width = height
                }
            } else {
                width = 0
            }
        case .custom:
            width = nil
        }
        if let width = width {
            if let widthConstraint = widthConstraint {
                widthConstraint.constant = width
            } else {
                widthConstraint = badgeView.widthAnchor.constraint(equalToConstant: width)
                widthConstraint?.isActive = true
            }
        } else {
            widthConstraint?.isActive = false
            widthConstraint = nil
        }
    }
    
    private func updateCornerRadius() {
        switch type {
        case .none:
            break
        case .point, .count:
            badgeView.layer.cornerRadius = height/2
        case let .custom(_, _, cornerRadius):
            if let cornerRadius = cornerRadius {
                badgeView.layer.cornerRadius = cornerRadius
            } else {
                badgeView.layer.cornerRadius = height/2
            }
        }
    }
    
}
