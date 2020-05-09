
//
//  LanguageCenterHeaderView.swift
//  Example
//
//  Created by Jiar on 2018/12/14.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

class LanguageCenterHeaderView: UIView {

    @IBOutlet private weak var bgImageView: UIImageView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleTextLabel: UILabel!
    @IBOutlet private weak var summaryTextLabel: UILabel!
    @IBOutlet private weak var iconTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bgImageTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = 40
    }
    
    var bgImageViewHeight: CGFloat {
        return bgImageView.image?.size.height ?? bgImageView.bounds.height
    }
    
    func config(_ language: Language, viewController: UIViewController) {
        let topLayoutLength: CGFloat
        if #available(iOS 11.0, *) {
            topLayoutLength = viewController.view.safeAreaInsets.top
        } else {
            topLayoutLength = viewController.topLayoutGuide.length
        }
        iconTopConstraint.constant = topLayoutLength
        layoutIfNeeded()
        iconImageView.image = language.icon
        titleTextLabel.text = language.title
        summaryTextLabel.text = language.summary
    }
    
    func setBgImageTopConstraint(_ constant: CGFloat) {
        bgImageTopConstraint.constant = constant
        layoutIfNeeded()
    }

}
