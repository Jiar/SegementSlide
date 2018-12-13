//
//  BaseTableViewController.swift
//  Example
//
//  Created by Jiar on 2018/12/13.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    deinit {
        #if DEBUG
        print("\(type(of: self)) deinit")
        #endif
    }

}
