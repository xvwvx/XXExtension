//
//  NSObject+XXUserInfo.swift
//  Extension
//
//  Created by snow on 2018/7/21.
//  Copyright © 2018 snow. All rights reserved.
//

import Foundation

extension Namespace: XXStorageProtocol where Base: NSObject {
    
    public var userInfo: [String: Any] {
        get {
            return self.base.xx_userInfo
        }
        mutating set {
            self.base.xx_userInfo = newValue
        }
    }
    
    public mutating func set<T>(_ value: T, forKey defaultName: String, ignoreType: Bool = false) {
        var userInfo = self.userInfo
        if !ignoreType && userInfo[defaultName] != nil {
            let oldValue = userInfo[defaultName]!
            if !(oldValue is T) {
                fatalError("value 与 oldValue 类型不一致")
            }
        }
        userInfo[defaultName] = value
        self.userInfo = userInfo
    }
    
    public func get<T>(forKey defaultName: String) -> T? {
        return self.userInfo[defaultName] as? T
    }
}

private var AssociatedKey: UInt8 = 0
extension NSObject {
    var xx_userInfo: [String: Any] {
        get {
            var userInfo = objc_getAssociatedObject(self, &AssociatedKey) as? [String: Any]
            if userInfo == nil {
                userInfo = [String: Any]()
                self.xx_userInfo = userInfo!
            }
            return userInfo!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

