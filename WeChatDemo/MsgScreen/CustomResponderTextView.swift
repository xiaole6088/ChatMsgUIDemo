//
//  CustomResponderTextView.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/12.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

class CustomResponderTextView: UITextView {

    weak var overrideNext: UIResponder?
    
    override var next: UIResponder? {
        if let responder = overrideNext { return responder }
        return super.next
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if overrideNext != nil { return false }
        return super.canPerformAction(action, withSender: sender)
    }

}
