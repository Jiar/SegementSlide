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
    case count(Int)
}

internal final class BadgeView: UILabel {}

private var badgeKey: Void?

internal extension UIView {
    
    /// 为当前视图添加 Badge
    internal var badge: Badge {
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
    
    //MARK: public api
    
    /// Badge 支持的类型
    internal var type: BadgeType = .none {
        didSet {
            if case .count(let count) = type {
                badgeView.isHidden = count == 0
                let string: String
                if count > 99 {
                    string = "99+"
                } else {
                    string = "\(count)"
                }
                badgeView.text = string
            }
            remakeConstraints()
        }
    }
    
    /// 以『Badge的中心位置』相对于『父视图的中心位置』位移
    /// x为正数表示向右边移动
    /// y为正数表示向下边移动
    internal var offset: CGPoint = .zero {
        didSet {
            remakeConstraints()
        }
    }
    
    /// 只有 type 为 .count 时生效，该值为显示区域的 fontSize
    internal var fontSize: CGFloat = 13 {
        didSet {
            if case .count = type {
                updateFont()
            }
        }
    }
    
    /// Badge 的高度，Badge 的 cornerRadius 受该值影响，为该值一半
    internal var height: CGFloat = 9 {
        didSet {
            updateHeight()
        }
    }
    
    //MARK: private
    private let badgeView: BadgeView
    
    private var centerXConstraint: NSLayoutConstraint?
    private var centerYConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    
    internal init(_ superView: UIView) {
        badgeView = BadgeView()
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeView.backgroundColor = .red
        badgeView.layer.masksToBounds = true
        badgeView.numberOfLines = 1
        badgeView.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        badgeView.textColor = .white
        badgeView.textAlignment = .center
        superView.addSubview(badgeView)
    }
    
    private func remakeConstraints() {
        guard let _ = badgeView.superview else {
            return
        }
        if case .none = type {
            updateWidthConstraint()
        } else {
            updateCenterXConstraint()
            updateCenterYConstraint()
            updateHeightConstraint()
            updateWidthConstraint()
            updateCornerRadius()
        }
    }
    
    private func updateFont() {
        badgeView.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
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
        centerXConstraint?.isActive = false
        centerXConstraint = badgeView.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: offset.x)
        centerXConstraint?.isActive = true
    }
    
    private func updateCenterYConstraint() {
        guard let superView = badgeView.superview else {
            return
        }
        centerYConstraint?.isActive = false
        centerYConstraint = badgeView.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: offset.y)
        centerYConstraint?.isActive = true
    }
    
    private func updateHeightConstraint() {
        heightConstraint?.isActive = false
        heightConstraint = badgeView.heightAnchor.constraint(equalToConstant: height)
        heightConstraint?.isActive = true
    }
    
    private func updateWidthConstraint() {
        widthConstraint?.isActive = false
        switch type {
        case .none:
            widthConstraint = badgeView.widthAnchor.constraint(equalToConstant: 0)
        case .point:
            widthConstraint = badgeView.widthAnchor.constraint(equalToConstant: height)
        case .count(let count):
            if count > 0, let string = badgeView.text {
                if count >= 10 {
                    widthConstraint = badgeView.widthAnchor.constraint(equalToConstant: string.boundingWidth(with: badgeView.font)+(height-"0".boundingWidth(with: badgeView.font)))
                } else {
                    widthConstraint = badgeView.widthAnchor.constraint(equalToConstant: height)
                }
            } else {
                widthConstraint = badgeView.widthAnchor.constraint(equalToConstant: 0)
            }
        }
        widthConstraint?.isActive = true
    }
    
    private func updateCornerRadius() {
        badgeView.layer.cornerRadius = height/2
    }
    
}
