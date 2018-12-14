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
    
    func segementSwitcherView(_ segementSlideSwitcherView: SegementSlideSwitcherView, didSelectAtIndex index: Int)
    func segementSwitcherView(_ segementSlideSwitcherView: SegementSlideSwitcherView, showBadgeAtIndex index: Int) -> BadgeType
}

internal class SegementSlideSwitcherView: UIView {
    
    private let scrollView = UIScrollView()
    private let indicatorView = UIView()
    private var indicatorViewLeadingConstraint: NSLayoutConstraint!
    private var indicatorViewTopConstraint: NSLayoutConstraint!
    private var indicatorViewWidthConstraint: NSLayoutConstraint!
    private var indicatorViewHeightConstraint: NSLayoutConstraint!
    private var titleButtons: [UIButton] = []
    
    internal var type: SwitcherType = .tab {
        didSet {
            guard oldValue != type else { return }
            layoutTitleButtons()
        }
    }
    internal var horizontalMargin: CGFloat = 16
    internal var horizontalSpace: CGFloat = 22
    internal var normalTitleFont = UIFont.systemFont(ofSize: 15)
    internal var selectedTitleFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    internal var normalTitleColor = UIColor.gray
    internal var selectedTitleColor = UIColor.darkGray
    internal var indicatorWidth: CGFloat = 30
    internal var indicatorHeight: CGFloat = 2
    internal var indicatorColor = UIColor.darkGray
    
    internal private(set) var selectedIndex: Int = 0
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
            make.edges.equalToSuperview()
        }
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(indicatorView)
        indicatorView.layer.masksToBounds = true
        indicatorView.layer.cornerRadius = indicatorHeight/2
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0)
        indicatorViewTopConstraint = indicatorView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0)
        indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: 0)
        indicatorViewHeightConstraint = indicatorView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            indicatorViewLeadingConstraint,
            indicatorViewTopConstraint,
            indicatorViewWidthConstraint,
            indicatorViewHeightConstraint
        ])
        backgroundColor = .white
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleButtons()
        updateSelectedButton(animated: false)
        reloadBadges()
    }
    
    internal func reloadSwitcher() {
        for titleButton in titleButtons {
            titleButton.removeFromSuperview()
        }
        titleButtons.removeAll()
        scrollView.isScrollEnabled = type == .segement
        let titles = delegate?.titlesInSegementSlideSwitcherView() ?? []
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
        updateSelectedButton(animated: false)
        reloadBadges()
        delegate?.segementSwitcherView(self, didSelectAtIndex: selectedIndex)
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
            case .count(let count):
                titleButton.badge.height = 15
                titleButton.badge.fontSize = 10
                titleButton.badge.offset = CGPoint(x: x/2.0 + titleButton.badge.height/2+1, y: -y/2.0 + 1)
            case .point:
                titleButton.badge.height = 9
                titleButton.badge.offset = CGPoint(x: x/2.0 + titleButton.badge.height/2+1, y: -y/2.0 + 1)
            case .none:
                break
            }
        }
    }
    
    internal func selectSwitcher(at index: Int, animated: Bool) {
        guard index < titleButtons.count else { return }
        guard index != selectedIndex else { return }
        let titleButton = titleButtons[selectedIndex]
        titleButton.setTitleColor(normalTitleColor, for: .normal)
        titleButton.titleLabel?.font = normalTitleFont
        selectedIndex = index
        layoutTitleButtons()
        updateSelectedButton(animated: animated)
        delegate?.segementSwitcherView(self, didSelectAtIndex: index)
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
        for (index, titleButton) in titleButtons.enumerated() {
            let buttonWidth: CGFloat
            switch type {
            case .tab:
                buttonWidth = (bounds.width-horizontalMargin*2)/CGFloat(titleButtons.count)
            case .segement:
                let title = titleButton.title(for: .normal) ?? ""
                buttonWidth = title.boundingWidth(with: index == selectedIndex ? selectedTitleFont : normalTitleFont)
            }
            titleButton.snp.remakeConstraints { make in
                make.leading.equalTo(scrollView.snp.leading).offset(offsetX)
                make.top.equalTo(scrollView.snp.top)
                make.width.equalTo(buttonWidth)
                make.height.equalTo(bounds.height)
            }
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
    
    private func updateSelectedButton(animated: Bool) {
        guard scrollView.frame != .zero else { return }
        let titleButton = titleButtons[selectedIndex]
        titleButton.setTitleColor(selectedTitleColor, for: .normal)
        titleButton.titleLabel?.font = selectedTitleFont
        if animated {
            scrollView.layoutIfNeeded()
            UIView.animate(withDuration: 0.25) {
                self.indicatorViewLeadingConstraint.constant = titleButton.frame.origin.x+(titleButton.bounds.width-self.indicatorWidth)/2
                self.indicatorViewTopConstraint.constant = self.frame.height-self.indicatorHeight
                self.indicatorViewWidthConstraint.constant = self.indicatorWidth
                self.indicatorViewHeightConstraint.constant = self.indicatorHeight
                self.scrollView.layoutIfNeeded()
            }
        } else {
            indicatorViewLeadingConstraint.constant = titleButton.frame.origin.x+(titleButton.bounds.width-indicatorWidth)/2
            indicatorViewTopConstraint.constant = frame.height-indicatorHeight
            indicatorViewWidthConstraint.constant = indicatorWidth
            indicatorViewHeightConstraint.constant = indicatorHeight
            scrollView.layoutIfNeeded()
        }
        guard case .segement = type else { return }
        var offsetX = titleButton.frame.origin.x-(scrollView.bounds.width-titleButton.bounds.width)/2
        if offsetX < 0 {
            offsetX = 0
        } else if (offsetX+scrollView.bounds.width) > scrollView.contentSize.width {
            offsetX = scrollView.contentSize.width-scrollView.bounds.width
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
    }
    
    @objc private func didClickTitleButton(_ button: UIButton) {
        selectSwitcher(at: button.tag, animated: true)
    }
    
}
