//
//  UIView+XXCollapsibleConstraints.swift
//  test
//
//  Created by snow on 2018/7/21.
//  Copyright © 2018 snow. All rights reserved.
//  https://github.com/forkingdog/UIView-FDCollapsibleConstraints

import UIKit

private var AssociatedKey: UInt8 = 0
private var AutoCollapseAssociatedKey: UInt8 = 0

extension UIView {
    fileprivate class InternalData {
        var collapsed = false
        var collapsibleConstraints = [NSLayoutConstraint]()
        var newCollapsibleConstraints = [NSLayoutConstraint]()
        weak var collapsedAnimationView: UIView?
    }
    
    fileprivate var data: InternalData {
        var value = objc_getAssociatedObject(self, &AssociatedKey)
        if value == nil {
            value = InternalData()
            objc_setAssociatedObject(self, &AssociatedKey, value!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return value! as! InternalData
    }
}

extension UIView {
    private static let _initialize:() = {
        Runtime.exchangeInstanceMethod(UIView.self,
                                       original: #selector(updateConstraints),
                                       swizzled: #selector(xx_updateConstraints))
        
        Runtime.exchangeInstanceMethod(UIView.self,
                                       original: #selector(setValue(_:forKey:)),
                                       swizzled: #selector(xx_setValue(_:forKey:)))
    }()
    
    @objc private func xx_setValue(_ value: Any?, forKey key: String) {
        let injectedKey = String(cString: sel_getName(#selector(xx_updateConstraints)))
        if key == injectedKey {
            xx_collapsibleConstraints = value as! [NSLayoutConstraint]
        } else {
          self.xx_setValue(value, forKey: key)
        }
    }
    
    @IBOutlet public var xx_collapsibleConstraints: [NSLayoutConstraint] {
        get {
            return data.collapsibleConstraints
        }
        set {
            UIView._initialize
            data.collapsibleConstraints = newValue
        }
    }
    
    @IBOutlet public weak var xx_collapsedAnimationView: UIView? {
        get {
            return data.collapsedAnimationView
        }
        set {
            data.collapsedAnimationView = newValue
        }
    }
    
    @objc public var xx_collapsed: Bool {
        get {
            return data.collapsed
        }
        set {
            self.xx_setCollapsed(newValue, animationView: self.data.collapsedAnimationView)
        }
    }
    
    @objc @IBInspectable public var autoCollapse: Bool {
        get {
            fatalError("禁止使用该方法")
        }
        set {
            self.xx_autoCollapse = newValue
        }
    }
    
    @objc public var xx_autoCollapse: Bool {
        get {
            return objc_getAssociatedObject(self, &AutoCollapseAssociatedKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AutoCollapseAssociatedKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // 当 animationView 为 nil 时 没有动画效果
    @objc public func xx_setCollapsed(_ collapsed: Bool, animationView: UIView?) {
        data.collapsed = collapsed
        if collapsed {
            if self.data.collapsibleConstraints.count != self.data.newCollapsibleConstraints.count {
                self.data.newCollapsibleConstraints.removeAll()
                self.data.collapsibleConstraints.forEach { (constraint) in
                    let newConstraint = NSLayoutConstraint(item: constraint.firstItem!,
                                                           attribute: constraint.firstAttribute,
                                                           relatedBy: .equal,
                                                           toItem: constraint.secondItem,
                                                           attribute: constraint.secondAttribute,
                                                           multiplier: 1,
                                                           constant: 0)
                    self.data.newCollapsibleConstraints.append(newConstraint)
                }
            }
            
            NSLayoutConstraint.deactivate(self.data.collapsibleConstraints)
            NSLayoutConstraint.activate(self.data.newCollapsibleConstraints)
        } else {
            NSLayoutConstraint.deactivate(self.data.newCollapsibleConstraints)
            NSLayoutConstraint.activate(self.data.collapsibleConstraints)
        }
        
        if animationView != nil {
            UIView.animate(withDuration: 0.3) {
                animationView!.layoutIfNeeded()
            }
        }
    }
    
    @objc private func xx_updateConstraints() {
        self.xx_updateConstraints()
        
        if self.xx_autoCollapse && self.xx_collapsibleConstraints.count > 0 {
            let contentSize = self.intrinsicContentSize
//            let noIntrinsicSize = CGSize(width: UIViewNoIntrinsicMetric,
//                                         height: UIViewNoIntrinsicMetric)
//
//            let collapsed contentSize == noIntrinsicSize || contentSize == CGSize.zero
            
            let collapsed = contentSize.width <= 0 || contentSize.height <= 0
            self.xx_setCollapsed(collapsed, animationView: nil)
        }
    }
}

extension UIView {
    @available(*, deprecated, message: "请使用 xx_collapsed")
    @objc public var fd_collapsed: Bool {
        get {
            return xx_collapsed
        }
        set {
            xx_collapsed = newValue
        }
    }
    
    @available(*, deprecated, message: "请使用 xx_autoCollapse")
    @objc public var fd_autoCollapse: Bool {
        get {
            return xx_autoCollapse
        }
        set {
            xx_autoCollapse = newValue
        }
    }
}
