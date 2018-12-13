//
//  ContentViewCell.swift
//  Example
//
//  Created by Jiar on 2018/12/13.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

class ContentViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var summaryTextLabel: UILabel!
    
    static func estimatedRowHeight() -> CGFloat {
        return 88
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = 21
    }
    
    func config(_ language: Language) {
        iconImageView.image = language.icon
        titleTextLabel.text = language.title
        summaryTextLabel.text = language.summary
    }
    
}
