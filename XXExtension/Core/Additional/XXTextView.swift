//
//  XXTextView.swift
//  Extension
//
//  Created by snow on 2018/7/25.
//  Copyright © 2018 snow. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class XXTextView: UITextView {
    private lazy var placeholderLabel = { () -> UILabel in
        let label = XXPlaceholderLabel()
        label.font = self.font
        label.textAlignment = self.textAlignment
        
        self.addSubview(label)
        let attributes: [NSLayoutAttribute] = [.top, .left, .right, .bottom]
        let constraints = attributes.map { (attribute) -> NSLayoutConstraint in
            var constant = CGFloat(8)
            switch attribute {
            case .left, .right:
                constant = 5
            default:
                break
            }
            return NSLayoutConstraint(item: label,
                                      attribute: attribute,
                                      relatedBy: .equal,
                                      toItem: self,
                                      attribute: attribute,
                                      multiplier: 1,
                                      constant: constant)
        }
        self.addConstraints(constraints)
        return label
    }()
    
    @IBInspectable open var placeholder: String?
        {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    open var attributedPlaceholder:NSAttributedString?
    {
        didSet {
            placeholderLabel.attributedText = attributedPlaceholder
        }
    }
    
    @IBInspectable open var maxLength: Int = 0
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        let _ = self.rx.text.orEmpty
            .bind { [unowned self] text in
                self.placeholderLabel.isHidden = text.count > 0
            }
        
        if maxLength > 0 {
            let _ = self.rx.sentMessage(#selector(setter: text))
                .startWith([self.text!])
                .subscribe(onNext: { [unowned self] (any) in
                    let text = any.first! as! String
                    self.lastText = text
                    if self.maxLength < text.count {
                        self.maxLength = text.count
                    }
                })
            
            var disposable: Disposable?
            let _ = self.rx.sentMessage(#selector(UIResponder.becomeFirstResponder))
                .subscribe(onNext: { [unowned self] _ in
                    disposable = NotificationCenter.default.rx.notification(.UITextViewTextDidChange)
                        .subscribe(onNext: { [unowned self] _ in
                            self.xx_editingChanged()
                        })
                })
            
            let _ = self.rx.sentMessage(#selector(UIResponder.resignFirstResponder))
                .subscribe(onNext: { _ in
                    disposable?.dispose()
                })
        }
    }
    
    var lastText = ""
    private func xx_editingChanged() {
        var text = self.text ?? ""
        if text.count < lastText.count ||
            text.count <= self.maxLength {
            self.lastText = text
            return
        }
        var range = self.xx_selectedRange()
        let startIndex = text.index(text.startIndex, offsetBy: range.location - (text.count - lastText.count))
        let endIndex = text.index(text.startIndex, offsetBy: range.location)
        range.location -= text.count - self.maxLength
        let removeRange = Range<String.Index>(uncheckedBounds: (lower: startIndex, upper: endIndex))
        text.removeSubrange(removeRange)
        self.text = text
        self.xx_setSelectedRange(range: range)
    }
}

