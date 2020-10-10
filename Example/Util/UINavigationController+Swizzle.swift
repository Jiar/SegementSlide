//
//  UINavigationController+Swizzle.swift
//  Example
//
//  Created by Jiar on 2019/1/19.
//  Copyright © 2019 Jiar. All rights reserved.
//

import UIKit

internal extension UINavigationController {
    
    static func setupSwizzleForUINavigationController() {
        guard self === UINavigationController.self else {
            return
        }
        let originalSelectors = [#selector(UINavigationController.pushViewController(_:animated:))]
        let swizzledSelectors = [#selector(UINavigationController.newPushViewController(_:animated:))]
        for (index, originalSelector) in originalSelectors.enumerated() {
            let swizzledSelector = swizzledSelectors[index]
            if let originalMethod = class_getInstanceMethod(self, originalSelector),
                let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) {
                let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
                if didAddMethod {
                    class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
                } else {
                    method_exchangeImplementations(originalMethod, swizzledMethod)
                }
            }
        }
    }
    
    @objc
    private func newPushViewController(_ viewController: UIViewController, animated: Bool) {
        guard viewControllers.count > 0 else {
            newPushViewController(viewController, animated: animated)
            return
        }
        viewControllers.last?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "  ", style: .plain, target: nil, action: nil)
        newPushViewController(viewController, animated: animated)
    }
    
}
