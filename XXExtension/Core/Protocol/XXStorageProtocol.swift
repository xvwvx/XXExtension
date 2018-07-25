//
//  IStorage.swift
//  Extension
//
//  Created by snow on 2018/7/23.
//  Copyright © 2018 snow. All rights reserved.
//

import Foundation

public protocol XXStorageProtocol {
    mutating func set<T>(_ value: T, forKey defaultName: String, ignoreType: Bool)
    func get<T>(forKey defaultName: String) -> T?
}

extension XXStorageProtocol {
    public func isExist(forKey defaultName: String) -> Bool {
        return self.get(forKey: defaultName) != nil
    }
    
    public func number(forKey defaultName: String) -> NSNumber {
        let value: NSNumber? = self.get(forKey: defaultName)
        return value ?? 0
    }
    
    public func integer(forKey defaultName: String) -> Int {
        let value: Int? = self.get(forKey: defaultName)
        return value ?? 0
    }
    
    public func float(forKey defaultName: String) -> Float {
        let value: Float? = self.get(forKey: defaultName)
        return value ?? 0
    }
    
    public func double(forKey defaultName: String) -> Double {
        let value: Double? = self.get(forKey: defaultName)
        return value ?? 0
    }
    
    public func string(forKey defaultName: String) -> String {
        let value: String? = self.get(forKey: defaultName)
        return value ?? ""
    }
    
    public func url(forKey defaultName: String) -> URL {
        let value: URL? = self.get(forKey: defaultName)
        return value!
    }
}
