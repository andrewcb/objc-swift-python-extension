//
//  Logic.swift
//  spam
//
//  Created by acb on 2020-06-18.
//  Copyright © 2020 acb. All rights reserved.
//

import Foundation

/// The Glue class,  which has only  @objc class methods, and is intended as an interface for Objective C code to call Swift code
public class Glue: NSObject {
    @objc public class func add(_ a: Int, _ b: Int) -> Int {
        print("This is in Swift")
        return a+b
    }
}

/// a class with an instance, Counter, which can be instantiated from the Python code through wrappers

public class Counter: NSObject {
    @objc public private(set) var count: Int = 0
    
    @objc public func increment() { count += 1 }
    @objc public func reset() { count = 0 }
}
