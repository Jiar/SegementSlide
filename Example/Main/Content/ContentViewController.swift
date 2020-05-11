//
//  ContentViewController.swift
//  Example
//
//  Created by Jiar on 2018/12/13.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SegementSlide
import MBProgressHUD
import MJRefresh

class ContentViewController: BaseTableViewController, SegementSlideContentScrollViewDelegate {
    
    @objc
    var scrollView: UIScrollView {
        return tableView
    }
    
    private var languages: [Language] = []
    internal var refreshHandler: (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic
        } else {
            automaticallyAdjustsScrollViewInsets = true
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = ContentViewCell.estimatedRowHeight()
        tableView.register(UINib(nibName: "ContentViewCell", bundle: nil), forCellReuseIdentifier: "ContentViewCell")
        let noneView = UIView()
        noneView.frame = .zero
        tableView.tableHeaderView = noneView
        tableView.tableFooterView = noneView
        let refreshHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        refreshHeader?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = refreshHeader
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreAction))
        tableView.mj_footer.isHidden = true
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.offset = CGPoint(x: 0, y: -self.view.bounds.height/5)
        }
        tableView.mj_header.executeRefreshingCallback()
    }
    
    internal func refresh() {
        tableView.mj_header.beginRefreshing()
    }
    
    @objc
    private func refreshAction() {
        if tableView.mj_footer.isRefreshing {
            tableView.mj_footer.endRefreshing()
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+Double.random(in: 0..<2)) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.languages.removeAll()
                self.languages.append(contentsOf: DataManager.shared.randomLanguages)
                self.tableView.mj_header.endRefreshing()
                self.tableView.reloadData()
                self.tableView.mj_footer.isHidden = false
                MBProgressHUD.hide(for: self.view, animated: true)
                self.refreshHandler?()
            }
        }
    }
    
    @objc
    private func loadMoreAction() {
        guard !tableView.mj_header.isRefreshing else {
            tableView.mj_footer.endRefreshing()
            return
        }
        DispatchQueue.global().asyncAfter(deadline: .now()+Double.random(in: 0..<2)) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.languages.append(contentsOf: DataManager.shared.randomLanguages)
                self.tableView.mj_footer.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentViewCell", for: indexPath) as! ContentViewCell
        cell.config(languages[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let language = languages[indexPath.row]
        if Bool.random() {
            present(BaseNavigationController(rootViewController: LanguageCenterViewController(id: language.id, isPresented: true)), animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(LanguageCenterViewController(id: language.id, isPresented: false), animated: true)
        }
    }
    
    deinit {
        debugPrint("\(type(of: self)) deinit")
    }

}
