//
//  UITextInput+XXRange.swift
//  Extension
//
//  Created by snow on 2018/7/25.
//  Copyright © 2018 snow. All rights reserved.
//

import UIKit

extension UITextInput {
    public func xx_selectedRange() -> NSRange {
        //开始位置
        let beginning = self.beginningOfDocument
        //光标选择区域
        let selectedRange = self.selectedTextRange
        //选择的开始位置
        let selectionStart = selectedRange?.start ?? UITextPosition()
        //选择的结束位置
        let selectionEnd = selectedRange?.end  ?? UITextPosition()
        //选择的实际位置
        let location = self.offset(from: beginning, to: selectionStart)
        //选择的长度
        let length = self.offset(from: selectionStart, to: selectionEnd)
        return NSRange(location: location, length: length);
    }
    
    public func xx_setSelectedRange(range: NSRange) {
        let beginning = self.beginningOfDocument
        let startPosition = self.position(from: beginning, offset: range.location) ?? UITextPosition()
        let endPosition = self.position(from: beginning, offset: range.location+range.length)
        if endPosition != nil {
            let selectionRange = self.textRange(from: startPosition, to: endPosition!)
            self.selectedTextRange = selectionRange
        }
    }
}
