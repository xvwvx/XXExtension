//
//  XXTextField.swift
//  Extension
//
//  Created by snow on 2018/7/25.
//  Copyright © 2018 snow. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class XXTextField: UITextField {
    @IBInspectable var maxLength: Int = 0
    override func awakeFromNib() {
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
            let _ = self.rx.controlEvent(.editingChanged)
                .subscribe(onNext: { [unowned self] _ in
                    self.xx_editingChanged()
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

