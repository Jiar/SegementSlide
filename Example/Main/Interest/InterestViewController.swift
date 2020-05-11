//
//  InterestViewController.swift
//  Example
//
//  Created by Jiar on 2020/5/8.
//  Copyright © 2020 Jiar. All rights reserved.
//

import UIKit
import SegementSlide
import MJRefresh

class InterestViewController: BaseSegementSlideCustomViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Interest"
        tabBarItem = UITabBarItem(title: "Interest", image: UIImage(named: "tab_interest")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_interest_sel")?.withRenderingMode(.alwaysOriginal))
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func segementSlideHeaderView() -> UIView? {
        let headerView = UIImageView()
        headerView.isUserInteractionEnabled = true
        headerView.contentMode = .scaleAspectFill
        headerView.image = UIImage(named: "bg_working.png")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(equalToConstant: view.bounds.height/4).isActive = true
        return headerView
    }
    
    override var titlesInSwitcher: [String] {
        return DataManager.shared.interestLanguageTitles
    }
    
    override var badgesInSwitcher: [Int] {
        let count = DataManager.shared.interestLanguageTitles.count
        let badges = (0 ..< count).map({ _ in Int.random(in: 0..<10) })
        return badges
    }
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        return ContentViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        refreshHeader?.lastUpdatedTimeLabel.isHidden = true
        scrollView.mj_header = refreshHeader
        defaultSelectedIndex = 0
        reloadData()
    }
    
    @objc
    private func refreshAction() {
        DispatchQueue.global().asyncAfter(deadline: .now()+Double.random(in: 0..<2)) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.reloadSwitcher()
                self.scrollView.mj_header.endRefreshing()
            }
        }
    }

}
