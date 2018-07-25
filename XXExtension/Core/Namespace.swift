//
//  Namespace.swift
//  CRM
//
//  Created by snow on 2018/4/28.
//

import Foundation

public struct Namespace<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol NamespaceCompatible {
    associatedtype CompatibleType
    static var xx: Namespace<CompatibleType>.Type { get set }
    var xx: Namespace<CompatibleType> { get set }
}

extension NamespaceCompatible {
    public static var xx: Namespace<Self>.Type {
        get {
            return Namespace<Self>.self
        }
        set {
            // this enables using Reactive to "mutate" base type
        }
    }
    
    public var xx: Namespace<Self> {
        get {
            return Namespace(self)
        }
        set {
            // this enables using Reactive to "mutate" base object
        }
    }
}

import class Foundation.NSObject

extension NSObject: NamespaceCompatible { }
