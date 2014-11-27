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
        object_setClass(storyboard, InjectableStoryboard.self)
        storyboard.injector = AppBuilder()

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let rootViewController = storyboard.instantiateInitialViewController() as UIViewController
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
        return true
    }
}
