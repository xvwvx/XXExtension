//
//  XXCheckProtocol.swift
//  Extension
//
//  Created by snow on 2018/7/24.
//  Copyright © 2018 snow. All rights reserved.
//

import UIKit

protocol XXCheckProtocol {
    var check_emptyMsg: String? {get set}
    var check_regMsg: String? {get set}
    var check_regFunc: (()->Bool)? {get set}
    func check_isPassed() -> Bool
    func check_clear() -> Void
}

private var AssociatedKey = 0
extension UIView {
    fileprivate class InternalData {
        var emptyMsg: String?
        var regFunc: (()->Bool)?
        var regMsg:String?
        var regRule: String? {
            didSet {
                if regRule?.count == 0 {
                    regPredicate = nil
                }else {
                    regPredicate = NSPredicate(format: "SELF MATCHES %@", regRule!)
                }
            }
        }
        var regPredicate: NSPredicate?
        var frontViews: [UIView]?
        var errLabel:UILabel?
    }
    
    fileprivate var data: InternalData {
        var value = objc_getAssociatedObject(self, &AssociatedKey)
        if value == nil {
            value = InternalData()
            objc_setAssociatedObject(self, &AssociatedKey, value!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            checkInitialize()
        }
        return value! as! InternalData
    }
    
    @objc fileprivate func checkInitialize() {
        
    }
    
    fileprivate func check_isPassedText(text: String) -> Bool {
        if data.emptyMsg?.count != 0 && text == "" {
            self.showErrMsg(msg: data.emptyMsg!)
            return false
        }
        if data.regFunc != nil &&
            !data.regFunc!() {
            self.showErrMsg(msg: data.regMsg!)
            return false
        }
        if data.regPredicate != nil &&
            !data.regPredicate!.evaluate(with: text) {
            self.showErrMsg(msg: data.regMsg!)
            return false
        }
        return true
    }
    
    fileprivate func showErrMsg(msg: String) {
        if data.errLabel == nil {
            let maskView = UIView()
            maskView.isUserInteractionEnabled = false
            maskView.translatesAutoresizingMaskIntoConstraints = false
            //            maskView.backgroundColor = UIColor(red: 0xfe / 255.0 , green: 0xf4 / 255.0, blue: 0xf3 / 255.0, alpha: 0.7)
            maskView.backgroundColor = UIColor.red.withAlphaComponent(0.15)
            
            superview!.addSubview(maskView)
            var attributes: [NSLayoutAttribute] = [.top, .left, .right, .bottom]
            var constraints = attributes.map { (attribute) -> NSLayoutConstraint in
                return NSLayoutConstraint(item: maskView,
                                          attribute: attribute,
                                          relatedBy: .equal,
                                          toItem: superview!,
                                          attribute: attribute,
                                          multiplier: 1,
                                          constant: 0)
            }
            superview?.addConstraints(constraints)
            //            NSLayoutConstraint.activate(constraints)
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .red
            label.textAlignment = .right
            label.numberOfLines = 0
            label.font = .systemFont(ofSize: 14)
            
            maskView.addSubview(label)
            attributes = [.top, .left, .right, .bottom]
            constraints = attributes.map { (attribute) -> NSLayoutConstraint in
                var constant = CGFloat(10)
                switch attribute {
                case .bottom, .right:
                    constant = -constant
                default:
                    break
                }
                return NSLayoutConstraint(item: label,
                                          attribute: attribute,
                                          relatedBy: .equal,
                                          toItem: maskView,
                                          attribute: attribute,
                                          multiplier: 1,
                                          constant: constant)
            }
            
            maskView.addConstraints(constraints)
            //            NSLayoutConstraint.activate(constraints)
            
            data.frontViews?.forEach({ (view) in
                self.superview!.bringSubview(toFront: view)
            })
            
            data.errLabel = label
        }
        data.errLabel?.superview?.isHidden = false
        data.errLabel?.text = msg
    }
}

//MARK: - UIView
extension UIView: XXCheckProtocol {
    
    @objc @IBInspectable var check_emptyMsg: String? {
        get {
            return data.emptyMsg
        }
        set {
            data.emptyMsg = newValue
        }
    }
    
    @objc @IBInspectable var check_regMsg: String? {
        get {
            return data.regMsg
        }
        set {
            data.regMsg = newValue
        }
    }
    
    @objc var check_regFunc: (() -> Bool)? {
        get {
            return data.regFunc
        }
        set {
            data.regFunc = newValue
        }
    }
    
    @objc @IBOutlet var check_frontViews:[UIView]?{
        get {
            return data.frontViews
        }
        set {
            data.frontViews = newValue
        }
    }
    
    @objc func check_isPassed() -> Bool {
        if !data.regFunc!() {
            self.showErrMsg(msg: data.regMsg!)
            return false
        }
        return true
    }
    
    @objc func check_clear() -> Void {
        data.errLabel?.superview?.isHidden = true
    }
}

//MARK: - UILabel
extension UILabel {
    override func checkInitialize() {
        let _ = self.rx.sentMessage(#selector(setter: text))
            .subscribe(onNext: { [unowned self] _ in
                self.check_isPassed()
            })
    }
    
    @discardableResult
    override func check_isPassed() -> Bool {
        let text = self.attributedText?.string ?? self.text ?? ""
        return check_isPassedText(text: text)
    }
    
    @objc @IBInspectable var check_regRule: String? {
        get {
            return data.regRule
        }
        set {
            data.regRule = newValue
        }
    }
}


import RxCocoa

//MARK: - UITextField
extension UITextField {
    override func checkInitialize() {
        let _ = self.rx.sentMessage(#selector(UIResponder.becomeFirstResponder))
            .subscribe(onNext: { [unowned self] _ in
                self.check_clear()
            })
        
        let _ = self.rx.sentMessage(#selector(UIResponder.resignFirstResponder))
            .subscribe(onNext: { [unowned self] _ in
                self.check_isPassed()
            })
    }
    
    @discardableResult
    override func check_isPassed() -> Bool {
        return check_isPassedText(text: self.text!)
    }
    
    @objc @IBInspectable var check_regRule: String? {
        get {
            return data.regRule
        }
        set {
            data.regRule = newValue
        }
    }
}

//MARK: - UITextView
extension UITextView {
    override func checkInitialize() {
        let _ = self.rx.sentMessage(#selector(UIResponder.becomeFirstResponder))
            .subscribe(onNext: { [unowned self] _ in
                self.check_clear()
            })
        
        let _ = self.rx.sentMessage(#selector(UIResponder.resignFirstResponder))
            .subscribe(onNext: { [unowned self] _ in
                self.check_isPassed()
            })
    }
    
    @discardableResult
    override func check_isPassed() -> Bool {
        return check_isPassedText(text: self.text!)
    }
    
    @objc @IBInspectable var check_regRule: String? {
        get {
            return data.regRule
        }
        set {
            data.regRule = newValue
        }
    }
}


