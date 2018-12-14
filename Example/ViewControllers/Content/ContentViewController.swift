//
//  ContentViewController.swift
//  Example
//
//  Created by Jiar on 2018/12/13.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SegementSlide

class ContentViewController: BaseTableViewController, SegementSlideContentScrollViewDelegate {
    
    var scrollView: UIScrollView {
        return tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = ContentViewCell.estimatedRowHeight()
        tableView.register(UINib(nibName: "ContentViewCell", bundle: nil), forCellReuseIdentifier: "ContentViewCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        } else {
            tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: bottomLayoutGuide.length, right: 0)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.allLanguages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentViewCell", for: indexPath) as! ContentViewCell
        cell.config(DataManager.shared.allLanguages[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let language = DataManager.shared.allLanguages[indexPath.row]
        navigationController?.pushViewController(LanguageCenterViewController(id: language.id), animated: true)
    }

}
