//
//  UIStoryboardExtension.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 31/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

typealias UIViewControllerInjector = (UIViewController) -> ()
typealias StoryboardIdentifier = String

class UIStoryboardInjector {
    var controllerDependencies = [StoryboardIdentifier: UIViewControllerInjector] ()

    private func injectControllerDependencies(controller: UIViewController, var identifier: String = "") {
        identifier = controller.restorationIdentifier ?? identifier
        controllerDependencies[identifier]?(controller)
        for childController in controller.childViewControllers as [UIViewController] {
            injectControllerDependencies(childController)
        }
    }
}

private var key = Selector("injector")

// add injector property to the UIStoryboard class
extension UIStoryboard {
    var injector: UIStoryboardInjector? {
        get {
            return objc_getAssociatedObject(self, &key) as? UIStoryboardInjector
        }
        set(newValue) {
            objc_setAssociatedObject(self, &key, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
}

// for injector to do its work UIStoryboard instance's class should be switched at runtime to InjectableStoryboard using object_setClass
class InjectableStoryboard: UIStoryboard {
    override func instantiateViewControllerWithIdentifier(identifier: String) -> AnyObject! {
        let vc = super.instantiateViewControllerWithIdentifier(identifier) as UIViewController!
        injector?.injectControllerDependencies(vc, identifier: identifier)
        return vc
    }
}
