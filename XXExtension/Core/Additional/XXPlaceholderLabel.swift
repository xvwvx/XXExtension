//
//  XXPlaceholderLabel.swift
//  Extension
//
//  Created by snow on 2018/7/25.
//  Copyright © 2018 snow. All rights reserved.
//

import UIKit

class XXPlaceholderLabel: UILabel {
    init() {
        super.init(frame: CGRect.zero)
        
        self.textAlignment = .left
        self.font = UIFont.systemFont(ofSize: 17)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = false
        self.backgroundColor = .clear
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
        self.textColor = UIColor.gray.withAlphaComponent(0.7)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
