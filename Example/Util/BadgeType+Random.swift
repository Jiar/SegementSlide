//
//  BadgeType+Random.swift
//  Example
//
//  Created by Jiar on 2018/12/29.
//  Copyright © 2018 Jiar. All rights reserved.
//

import SegementSlide

extension BadgeType: CaseIterable {
    
    public static var allCases: [BadgeType] {
        return [
            .none, .none, .none, .none, .none,
            .point, .point, .point, .point, .point,
            .count(1), .count(3), .count(6), .count(10), .count(15),
            .count(21), .count(36), .count(99), .count(888), .count(1001),
            imageHotMark, imageHotMark, imageHotMark, imageHotMark, imageHotMark,
            richTextHotMark, richTextHotMark, richTextHotMark, richTextHotMark, richTextHotMark,
            richTextNewMark, richTextNewMark, richTextNewMark, richTextNewMark, richTextNewMark
        ]
    }
    
    internal static var random: BadgeType {
        let index = Int(arc4random_uniform(UInt32(BadgeType.allCases.count)))
        return BadgeType.allCases[index]
    }
    
    private static var imageHotMark: BadgeType {
        let hotImageAttachment = NSTextAttachment()
        hotImageAttachment.image = UIImage(named: "mark_hot_red")
        return .custom(NSAttributedString(attachment: hotImageAttachment), nil, nil)
    }
    
    private static var richTextHotMark: BadgeType {
        let height: CGFloat = ConfigManager.shared.switcherConfig.badgeHeightForCustomType
        let font = UIFont.systemFont(ofSize: 8, weight: .medium)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.minimumLineHeight = height
        paragraphStyle.maximumLineHeight = height
        
        let lineHeight: CGFloat = height
        let ascender: CGFloat = font.ascender/font.lineHeight*lineHeight
        let descender: CGFloat =  font.descender/font.lineHeight*lineHeight
        let baselineOffset = descender+(lineHeight-font.lineHeight)/2-font.descender
        
        let spaceString = NSMutableAttributedString(string: " ", attributes: [NSAttributedString.Key.baselineOffset: 0, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let contentString = NSMutableAttributedString(string: "HOT", attributes: [NSAttributedString.Key.baselineOffset: baselineOffset, NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let hotImageAttachment = NSTextAttachment()
        hotImageAttachment.image = UIImage(named: "mark_hot_white")
        hotImageAttachment.bounds = CGRect(x: 0, y: descender/2, width: ascender, height: ascender)
        let hotImageAttachmentString = NSMutableAttributedString(attachment: hotImageAttachment)
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(spaceString)
        attributedString.append(contentString)
        attributedString.append(hotImageAttachmentString)
        attributedString.append(spaceString)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.backgroundColor: UIColor.red], range: NSRange(location: 0, length: attributedString.length))
        
        return .custom(attributedString, height, nil)
    }
    
    private static var richTextNewMark: BadgeType {
        let height: CGFloat = ConfigManager.shared.switcherConfig.badgeHeightForCustomType
        let font = UIFont.systemFont(ofSize: 8, weight: .medium)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.minimumLineHeight = height
        paragraphStyle.maximumLineHeight = height
        
        let lineHeight: CGFloat = height
        let descender: CGFloat = font.descender/font.lineHeight*lineHeight
        let baselineOffset = descender+(lineHeight-font.lineHeight)/2-font.descender
        
        let spaceString = NSMutableAttributedString(string: " ", attributes: [NSAttributedString.Key.baselineOffset: 0, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let contentString = NSMutableAttributedString(string: "NEW", attributes: [NSAttributedString.Key.baselineOffset: baselineOffset, NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(spaceString)
        attributedString.append(contentString)
        attributedString.append(spaceString)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.backgroundColor: UIColor.red], range: NSRange(location: 0, length: attributedString.length))
        
        return .custom(attributedString, height, nil)
    }
    
}
