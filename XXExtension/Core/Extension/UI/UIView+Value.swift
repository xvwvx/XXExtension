//
//  UILabel+Value.swift
//  Extension
//
//  Created by snow on 2018/7/21.
//  Copyright © 2018 snow. All rights reserved.
//

import UIKit

//MARK: - UIView
extension Namespace where Base: UIView {
    public var value: Any? {
        get {
            fatalError("请实现实例的该方法")
        }
        set {
            fatalError("请实现实例的该方法")
        }
    }
}

//MARK: - UILabel
public extension Namespace where Base: UILabel {
    var value: Any? {
        get {
            return self.base.text
        }
        set {
            if newValue == nil {
                self.base.text = ""
            }else {
                let text = newValue! as! String
                self.base.text = text
            }
        }
    }
}

//MARK: - UITextView
public extension Namespace where Base: UITextView {
    var value: Any? {
        get {
            return self.base.text
        }
        set {
            if newValue == nil {
                self.base.text = ""
            }else {
                let text = newValue! as! String
                self.base.text = text
            }
        }
    }
}

//MARK: - UITextField
public extension Namespace where Base: UITextField {
    var value: Any? {
        get {
            return self.base.text
        }
        set {
            if newValue == nil {
                self.base.text = ""
            }else {
                let text = newValue! as! String
                self.base.text = text
            }
        }
    }
}

//MARK: - UIImageView
public extension Namespace where Base: UIImageView {
    var value: Any? {
        get {
            return self.base.image
        }
        set {
            if value == nil {
                self.base.image = nil
            }else if let image = newValue! as? UIImage {
                self.base.image = image
            }else {
                UIImageView.xx_handleValue(self.base, newValue!)
            }
        }
    }
}

public extension UIImageView {
    public static var xx_handleValue:((UIImageView, Any)-> Void) = { (_, _) in
        fatalError("请实现该方法")
    }
}


