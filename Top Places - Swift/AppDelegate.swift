//
//  AppDelegate.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let inTests = NSClassFromString("XCTest") != nil
        if inTests {
            return true
        }

        // initialize storyboard only if no tests are running
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabController = storyboard.instantiateInitialViewController() as TopPlacesTableViewController
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = tabController
        AppBuilder().buildAppWithRootViewController(tabController)

        window!.makeKeyAndVisible()
        return true
    }
}

