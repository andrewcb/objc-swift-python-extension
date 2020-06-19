//
//  Logic.swift
//  spam
//
//  Created by acb on 2020-06-18.
//  Copyright © 2020 acb. All rights reserved.
//

import Foundation

public class Glue: NSObject {
    @objc public class func add(_ a: Int, _ b: Int) -> Int {
        print("This is in Swift")
        return a+b
    }
}
