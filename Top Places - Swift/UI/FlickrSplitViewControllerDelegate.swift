//
//  FlickrSplitViewControllerDelegate.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 05/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class FlickrSplitViewControllerDelegate : UISplitViewControllerDelegate {
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }
}
    // landscape not collapsed
//    func splitViewController(splitViewController: UISplitViewController, separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController!) -> UIViewController? {
//        return
//    }
//}
