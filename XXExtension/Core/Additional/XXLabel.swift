//
//  XXLabel.swift
//  Extension
//
//  Created by snow on 2018/7/25.
//  Copyright © 2018 snow. All rights reserved.
//

import UIKit
import RxCocoa

open class XXLabel: UILabel {
    private lazy var placeholderLabel = { () -> UILabel in
        let label = XXPlaceholderLabel()
        label.font = self.font
        label.textAlignment = self.textAlignment
        
        self.superview!.addSubview(label)
        let attributes: [NSLayoutAttribute] = [.top, .left, .right, .bottom]
        let constraints = attributes.map { (attribute) -> NSLayoutConstraint in
            return NSLayoutConstraint(item: label,
                                      attribute: attribute,
                                      relatedBy: .equal,
                                      toItem: self,
                                      attribute: attribute,
                                      multiplier: 1,
                                      constant: 0)
        }
        self.superview!.addConstraints(constraints)
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
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        let _ = self.rx.sentMessage(#selector(setter: text))
            .startWith([self.text!])
            .subscribe(onNext: { [unowned self] (any) in
                let text = any.first as? String ?? ""
                self.placeholderLabel.isHidden = text.count != 0
            })
    }
}
