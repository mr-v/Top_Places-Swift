//
//  SplitViewControllerDelegate.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 05/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class SplitViewControllerDelegate : UISplitViewControllerDelegate {
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }
}
