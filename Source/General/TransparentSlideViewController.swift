//
//  TransparentSlideViewController.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

///
/// Set the navigationBar property in viewWillAppear
///
/// Why do you set properties in viewWillAppear instead of viewDidLoad?
/// - When enter to TransparentSlideViewController(B) from TransparentSlideViewController(A),
/// - viewDidLoad in B will take precedence over viewWillDisappear in A, so that it cannot recover state before displaying B.
///
/// Modifying the titleTextAttributes of navigationBar does not necessarily take effect immediately, so adjust the attributedText of the custom titleView instead.
///
open class TransparentSlideViewController: SegementSlideViewController {
    
    public typealias DisplayEmbed<T> = (display: T, embed: T)
    
    private weak var parentScrollView: UIScrollView? = nil
    private var titleLabel: UILabel!
    private var hasViewWillAppeared: Bool = false
    private var hasEmbed: Bool = false
    private var hasDisplay: Bool = false
    
    public weak var storedNavigationController: UINavigationController? = nil
    public var storedNavigationBarIsTranslucent: Bool? = nil
    public var storedNavigationBarBarStyle: UIBarStyle? = nil
    public var storedNavigationBarBarTintColor: UIColor? = nil
    public var storedNavigationBarTintColor: UIColor? = nil
    public var storedNavigationBarShadowImage: UIImage? = nil
    public var storedNavigationBarBackgroundImage: UIImage? = nil
    
    open override func segementSlideHeaderView() -> UIView {
        #if DEBUG
        assert(false, "must override this variable")
        #endif
        return UIView()
    }
    
    open var isTranslucents: DisplayEmbed<Bool> {
        return (true, false)
    }
    
    open var attributedTexts: DisplayEmbed<NSAttributedString?> {
        return (nil, nil)
    }
    
    open var barStyles: DisplayEmbed<UIBarStyle> {
        return (.black, .default)
    }
    
    open var barTintColors: DisplayEmbed<UIColor?> {
        return (nil, .white)
    }
    
    open var tintColors: DisplayEmbed<UIColor> {
        return (.white, .black)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutTitleLabel()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .top
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        layoutTitleLabel()
        navigationItem.titleView = titleLabel
    }
    
    private func layoutTitleLabel() {
        let titleSize: CGSize
        if let navigationController = navigationController {
            titleSize = CGSize(width: navigationController.navigationBar.bounds.width*3/5, height: navigationController.navigationBar.bounds.height)
        } else {
            titleSize = CGSize(width: view.bounds.width*3/5, height: 44)
        }
        if #available(iOS 11, *) {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.widthConstraint = titleLabel.widthAnchor.constraint(equalToConstant: titleSize.width)
            titleLabel.heightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: titleSize.height)
        } else {
            titleLabel.bounds = CGRect(origin: .zero, size: titleSize)
        }
    }
    
    public override func reloadData() {
        super.reloadData()
        reloadNavigationBarStyle()
    }
    
    public override func reloadHeader() {
        super.reloadHeader()
        reloadNavigationBarStyle()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hasViewWillAppeared = true
        storeDefaultNavigationBarStyle()
        reloadNavigationBarStyle()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        recoverStoredNavigationBarStyle()
    }
    
    open override func scrollViewDidScroll(_ scrollView: UIScrollView, isParent: Bool) {
        guard isParent else {
            return
        }
        guard parentScrollView != nil else {
            parentScrollView = scrollView
            return
        }
        updateNavigationBarStyle(scrollView)
    }
    
    open func storeDefaultNavigationBarStyle() {
        storedNavigationController = navigationController
        guard let navigationController = navigationController else {
            return
        }
        guard storedNavigationBarIsTranslucent == nil, storedNavigationBarBarStyle == nil,
            storedNavigationBarBarTintColor == nil, storedNavigationBarTintColor == nil,
            storedNavigationBarShadowImage == nil, storedNavigationBarBackgroundImage == nil else {
            return
        }
        storedNavigationBarIsTranslucent = navigationController.navigationBar.isTranslucent
        storedNavigationBarBarStyle = navigationController.navigationBar.barStyle
        storedNavigationBarBarTintColor = navigationController.navigationBar.barTintColor
        storedNavigationBarTintColor = navigationController.navigationBar.tintColor
        storedNavigationBarBackgroundImage = navigationController.navigationBar.backgroundImage(for: .default)
        storedNavigationBarShadowImage = navigationController.navigationBar.shadowImage
    }
    
    open func recoverStoredNavigationBarStyle() {
        guard let navigationController = navigationController else {
            return
        }
        navigationController.navigationBar.isTranslucent = storedNavigationBarIsTranslucent ?? false
        navigationController.navigationBar.barStyle = storedNavigationBarBarStyle ?? .default
        navigationController.navigationBar.barTintColor = storedNavigationBarBarTintColor
        navigationController.navigationBar.tintColor = storedNavigationBarTintColor
        navigationController.navigationBar.shadowImage = storedNavigationBarShadowImage
        navigationController.navigationBar.setBackgroundImage(storedNavigationBarBackgroundImage, for: .default)
    }
    
    public func reloadNavigationBarStyle() {
        guard let parentScrollView = parentScrollView else {
            return
        }
        hasDisplay = false
        hasEmbed = false
        updateNavigationBarStyle(parentScrollView)
    }
    
}

extension TransparentSlideViewController {
    
    private func updateNavigationBarStyle(_ scrollView: UIScrollView) {
        guard hasViewWillAppeared else {
            return
        }
        guard let navigationController = navigationController else {
            return
        }
        if scrollView.contentOffset.y >= headerStickyHeight {
            guard !hasEmbed else {
                return
            }
            hasEmbed = true
            hasDisplay = false
            titleLabel.attributedText = attributedTexts.embed
            titleLabel.layer.add(generateFadeAnimation(), forKey: "reloadTitleLabel")
            navigationController.navigationBar.isTranslucent = isTranslucents.embed
            navigationController.navigationBar.barStyle = barStyles.embed
            navigationController.navigationBar.tintColor = tintColors.embed
            navigationController.navigationBar.barTintColor = barTintColors.embed
            navigationController.navigationBar.layer.add(generateFadeAnimation(), forKey: "reloadNavigationBar")
        } else {
            guard !hasDisplay else {
                return
            }
            hasDisplay = true
            hasEmbed = false
            titleLabel.attributedText = attributedTexts.display
            titleLabel.layer.add(generateFadeAnimation(), forKey: "reloadTitleLabel")
            navigationController.navigationBar.isTranslucent = isTranslucents.display
            navigationController.navigationBar.barStyle = barStyles.display
            navigationController.navigationBar.tintColor = tintColors.display
            navigationController.navigationBar.barTintColor = barTintColors.display
            navigationController.navigationBar.layer.add(generateFadeAnimation(), forKey: "reloadNavigationBar")
        }
    }
    
    private func generateFadeAnimation() -> CATransition {
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.25
        fadeTextAnimation.type = .fade
        return fadeTextAnimation
    }
    
}
