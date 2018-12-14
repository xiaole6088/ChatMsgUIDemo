//
//  ChatEmotion.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/10.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

class ChatEmotion: NSObject {
    // MARK:- 定义属性
    var image: String? {   // 表情对应的图片名称
        didSet {
            imgPath = Bundle.main.bundlePath + "/Expression.bundle/" + image! + ".png"
        }
    }
    var text: String?     // 表情对应的文字
    
    // MARK:- 数据处理
    var imgPath: String?
    var isRemove: Bool = false
    var isEmpty: Bool = false
    
    override init() {
        super.init()
    }
    
    convenience init(dict: [String: String]) {
        self.init()
        for key in dict.keys {
            if key == "text" {
                self.text = dict[key]
            }
            if key == "image" {
                self.image = dict[key]
                self.imgPath = Bundle.main.bundlePath + "/Expression.bundle/" + dict[key]! + ".png"
            }
        }
    }
    
    init(isRemove: Bool) {
        self.isRemove = (isRemove)
    }
    init(isEmpty: Bool) {
        self.isEmpty = (isEmpty)
    }
}
