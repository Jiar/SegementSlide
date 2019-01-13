//
//  SegementSlideSwitcherView.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SnapKit

public enum SwitcherType {
    case tab
    case segement
}

internal protocol SegementSlideSwitcherViewDelegate: class {
    func titlesInSegementSlideSwitcherView() -> [String]
    
    func segementSwitcherView(_ segementSlideSwitcherView: SegementSlideSwitcherView, didSelectAtIndex index: Int, animated: Bool)
    func segementSwitcherView(_ segementSlideSwitcherView: SegementSlideSwitcherView, showBadgeAtIndex index: Int) -> BadgeType
}

internal class SegementSlideSwitcherView: UIView {
    
    private let scrollView = UIScrollView()
    private let indicatorView = UIView()
    private var titleButtons: [UIButton] = []
    
    internal var type: SwitcherType = .tab
    internal var horizontalMargin: CGFloat = 16
    internal var horizontalSpace: CGFloat = 22
    internal var normalTitleFont = UIFont.systemFont(ofSize: 15)
    internal var selectedTitleFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    internal var normalTitleColor = UIColor.gray
    internal var selectedTitleColor = UIColor.darkGray
    internal var indicatorWidth: CGFloat = 30
    internal var indicatorHeight: CGFloat = 2
    internal var indicatorColor = UIColor.darkGray
    
    private var initSelectedIndex: Int?
    internal private(set) var selectedIndex: Int?
    internal weak var delegate: SegementSlideSwitcherViewDelegate?
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(indicatorView)
        indicatorView.layer.masksToBounds = true
        indicatorView.layer.cornerRadius = indicatorHeight/2
        backgroundColor = .white
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleButtons()
        reloadBadges()
        if let initSelectedIndex = initSelectedIndex {
            self.initSelectedIndex = nil
            updateSelectedButton(at: initSelectedIndex, animated: false)
        }
    }
    
    internal func reloadData() {
        for titleButton in titleButtons {
            titleButton.removeFromSuperview()
        }
        titleButtons.removeAll()
        scrollView.isScrollEnabled = type == .segement
        guard let titles = delegate?.titlesInSegementSlideSwitcherView() else { return }
        guard !titles.isEmpty else { return }
        for (index, title) in titles.enumerated() {
            let button = UIButton(type: .custom)
            button.clipsToBounds = false
            button.titleLabel?.font = normalTitleFont
            button.backgroundColor = .clear
            button.setTitle(title, for: .normal)
            button.tag = index
            button.setTitleColor(normalTitleColor, for: .normal)
            button.addTarget(self, action: #selector(didClickTitleButton), for: .touchUpInside)
            scrollView.addSubview(button)
            titleButtons.append(button)
        }
        guard !titleButtons.isEmpty else { return }
        indicatorView.backgroundColor = indicatorColor
        layoutTitleButtons()
        reloadBadges()
        guard let selectedIndex = selectedIndex else { return }
        updateSelectedButton(at: selectedIndex, animated: false)
    }
    
    internal func reloadBadges() {
        for (index, titleButton) in titleButtons.enumerated() {
            guard let titleLabel = titleButton.titleLabel, let titleLabelText = titleLabel.text else {
                titleButton.badge.type = .none
                continue
            }
            guard let type = delegate?.segementSwitcherView(self, showBadgeAtIndex: index) else {
                titleButton.badge.type = .none
                continue
            }
            titleButton.badge.type = type
            if case .none = type {
                continue
            }
            let x = titleLabelText.boundingWidth(with: titleLabel.font)
            let y = titleLabel.font.lineHeight
            switch type {
            case .count:
                titleButton.badge.height = 15
                titleButton.badge.fontSize = 10
                titleButton.badge.offset = CGPoint(x: x/2+titleButton.badge.height/2+1, y: -y/2+1)
            case .point:
                titleButton.badge.height = 9
                titleButton.badge.offset = CGPoint(x: x/2+titleButton.badge.height/2+1, y: -y/2+1)
            case .none:
                break
            }
        }
    }
    
    internal func selectSwitcher(at index: Int, animated: Bool) {
        updateSelectedButton(at: index, animated: animated)
    }
    
}

extension SegementSlideSwitcherView {
    
    private func layoutTitleButtons() {
        guard scrollView.frame != .zero else { return }
        guard !titleButtons.isEmpty else {
            scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height)
            return
        }
        var offsetX = horizontalMargin
        for titleButton in titleButtons {
            let buttonWidth: CGFloat
            switch type {
            case .tab:
                buttonWidth = (bounds.width-horizontalMargin*2)/CGFloat(titleButtons.count)
            case .segement:
                let title = titleButton.title(for: .normal) ?? ""
                let normalButtonWidth = title.boundingWidth(with: normalTitleFont)
                let selectedButtonWidth = title.boundingWidth(with: selectedTitleFont)
                buttonWidth = selectedButtonWidth > normalButtonWidth ? selectedButtonWidth : normalButtonWidth
            }
            titleButton.frame = CGRect(x: offsetX, y: 0, width: buttonWidth, height: scrollView.bounds.height)
            scrollView.layoutIfNeeded()
            switch type {
            case .tab:
                offsetX += buttonWidth
            case .segement:
                offsetX += buttonWidth+horizontalSpace
            }
        }
        switch type {
        case .tab:
            scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height)
        case .segement:
            scrollView.contentSize = CGSize(width: offsetX-horizontalSpace+horizontalMargin, height: bounds.height)
        }
    }
    
    private func updateSelectedButton(at index: Int, animated: Bool) {
        guard scrollView.frame != .zero else {
            initSelectedIndex = index
            return
        }
        guard titleButtons.count != 0 else { return }
        if let selectedIndex = selectedIndex, selectedIndex >= 0, selectedIndex < titleButtons.count {
            let titleButton = titleButtons[selectedIndex]
            titleButton.setTitleColor(normalTitleColor, for: .normal)
            titleButton.titleLabel?.font = normalTitleFont
        }
        guard index >= 0, index < titleButtons.count else { return }
        let titleButton = titleButtons[index]
        titleButton.setTitleColor(selectedTitleColor, for: .normal)
        titleButton.titleLabel?.font = selectedTitleFont
        if animated, indicatorView.frame != .zero {
            UIView.animate(withDuration: 0.25) {
                self.indicatorView.frame = CGRect(x: titleButton.frame.origin.x+(titleButton.bounds.width-self.indicatorWidth)/2, y: self.frame.height-self.indicatorHeight, width: self.indicatorWidth, height: self.indicatorHeight)
            }
        } else {
            indicatorView.frame = CGRect(x: titleButton.frame.origin.x+(titleButton.bounds.width-indicatorWidth)/2, y: frame.height-indicatorHeight, width: indicatorWidth, height: indicatorHeight)
        }
        if case .segement = type {
            var offsetX = titleButton.frame.origin.x-(scrollView.bounds.width-titleButton.bounds.width)/2
            if offsetX < 0 {
                offsetX = 0
            } else if (offsetX+scrollView.bounds.width) > scrollView.contentSize.width {
                offsetX = scrollView.contentSize.width-scrollView.bounds.width
            }
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
        }
        guard index != selectedIndex else { return }
        selectedIndex = index
        delegate?.segementSwitcherView(self, didSelectAtIndex: index, animated: animated)
    }
    
    @objc private func didClickTitleButton(_ button: UIButton) {
        selectSwitcher(at: button.tag, animated: true)
    }
    
}
