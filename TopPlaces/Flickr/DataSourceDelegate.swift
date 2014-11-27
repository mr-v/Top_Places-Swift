//
//  DataSourceDelegate.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 25/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

protocol DataSourceDelegate: class {
    func dataSourceDidChangeContent()
}
