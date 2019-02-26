//
//  BaseTableViewController.swift
//  Example
//
//  Created by Jiar on 2019/2/26.
//  Copyright © 2019 Jiar. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
    }

}
