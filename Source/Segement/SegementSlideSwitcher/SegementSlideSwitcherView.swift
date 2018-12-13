//
//  SegementSlideSwitcherView.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

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
        translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        indicatorView.layer.masksToBounds = true
        indicatorView.layer.cornerRadius = indicatorHeight/2
        backgroundColor = .white
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.deactivate(scrollView.constraints)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        layoutTitleButtons()
        updateSelectedButton(animated: false)
    }
    
    internal func reloadSwitcher() {
        for titleButton in titleButtons {
            titleButton.removeFromSuperview()
        }
        titleButtons.removeAll()
        indicatorView.removeFromSuperview()
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
        scrollView.addSubview(indicatorView)
        if scrollView.frame != .zero {
            layoutTitleButtons()
            updateSelectedButton(animated: false)
        }
        delegate?.segementSwitcherView(self, didSelectAtIndex: selectedIndex)
    }
    
    internal func reloadBadges() {
        
    }
    
    internal func selectSwitcher(at index: Int, animated: Bool) {
        guard index < titleButtons.count else { return }
        guard index != selectedIndex else { return }
        let titleButton = titleButtons[selectedIndex]
        titleButton.setTitleColor(normalTitleColor, for: .normal)
        titleButton.titleLabel?.font = normalTitleFont
        selectedIndex = index
        if scrollView.frame != .zero {
            layoutTitleButtons()
            updateSelectedButton(animated: animated)
        }
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
            titleButton.frame = CGRect(x: offsetX, y: 0, width: buttonWidth, height: bounds.height)
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
        let titleButton = titleButtons[selectedIndex]
        titleButton.setTitleColor(selectedTitleColor, for: .normal)
        titleButton.titleLabel?.font = selectedTitleFont
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.indicatorView.frame = CGRect(x: titleButton.frame.origin.x+(titleButton.bounds.width-self.indicatorWidth)/2, y: self.frame.height-self.indicatorHeight, width: self.indicatorWidth, height: self.indicatorHeight)
            }
        } else {
            indicatorView.frame = CGRect(x: titleButton.frame.origin.x+(titleButton.bounds.width-indicatorWidth)/2, y: frame.height-indicatorHeight, width: indicatorWidth, height: indicatorHeight)
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
