//
//  ViewController.swift
//  Extension
//
//  Created by snow on 2018/7/21.
//  Copyright © 2018 snow. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Test: NSObject {
    var a = 55
    var b = 100
}

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func action(_ sender: Any) {
        if label.text == nil || label.text! == "" {
            label.text = "测试"
        }else {
            label.text = nil
        }
        textView.text = nil
        textField.text = nil
    }
}

