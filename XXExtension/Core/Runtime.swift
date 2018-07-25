//
//  Swizzled.swift
//  Extension
//
//  Created by snow on 2018/7/21.
//  Copyright © 2018 snow. All rights reserved.
//

import Foundation

class Runtime {
    static func exchangeInstanceMethod(_ cls: Swift.AnyClass?, original: Selector, swizzled: Selector) {
        let originalSelector = class_getInstanceMethod(cls.self, original)!
        let swizzledSelector = class_getInstanceMethod(cls.self, swizzled)!
        method_exchangeImplementations(originalSelector, swizzledSelector)
    }
    
    static func exchangeClassMethod(_ cls: Swift.AnyClass?, _ originalName: Selector, swizzledName: Selector) {
        let originalSelector = class_getClassMethod(cls.self, originalName)!
        let swizzledSelector = class_getClassMethod(cls.self, swizzledName)!
        method_exchangeImplementations(originalSelector, swizzledSelector)
    }
}
