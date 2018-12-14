//
//  ChatEmotionHelper.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/10.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

class ChatEmotionHelper: NSObject {
    // MARK:- 获取表情模型数组
    class func getAllEmotions() -> [ChatEmotion] {
        var emotions: [ChatEmotion] = [ChatEmotion]()
        let plistPath = Bundle.main.path(forResource: "Expression", ofType: "plist")
        let array = NSArray(contentsOfFile: plistPath!) as! [[String : String]]
        for dict in array {
            emotions.append(ChatEmotion(dict: dict))
        }
        return emotions
    }
    
    class func isEmotionStr(str: String) -> Bool {
        let emotions = getAllEmotions()
        let result = emotions.filter { (emo) -> Bool in
            return emo.text == str
            }.first
        
        if result != nil {
            return true
        }
        return false
    }
    
    class func getAllSectionEmotions(width: CGFloat) -> [[ChatEmotion]] {

        let plistPath = Bundle.main.path(forResource: "Expression", ofType: "plist")
        let array = NSArray(contentsOfFile: plistPath!) as! [[String : String]]
        
        let hCount = floor((width - (insetMargin * 2))/itemWidth)
        // 每页表情个数
        let itemCount: Float = Float(hCount * 3)
        let sectionCount: Int = Int(ceil(Float(array.count)/itemCount))
        let realCount = array.count + sectionCount
        // 表情页数
        let pageCount: Int = Int(ceil(Float(realCount)/itemCount))
        
        var newEmos: [[ChatEmotion]] = []
        
        // 表情总数(包括删除和空白占位)
//        let realAllCount = pageCount * Int(itemCount)
        
        var index: Int = 0
        for _ in 0..<pageCount {
            var sectionEmos: [ChatEmotion] = []
            for _ in 0..<(Int(itemCount) - 1) {
                if index < array.count {
                    // 真表情
                    let emo = ChatEmotion(dict: array[index])
                    index += 1
                    sectionEmos.append(emo)
                } else {
                    // 空白表情占位
                    let empty = ChatEmotion(isEmpty: true)
                    sectionEmos.append(empty)
                }
            }
            let remove = ChatEmotion(isRemove: true)
            sectionEmos.append(remove)
            
            var newSectionEmos: [ChatEmotion] = []
            for i in 0..<Int(hCount) {
                for j in 0..<3 {
                    let newIndex = j * Int(hCount) + i
                    newSectionEmos.append(sectionEmos[newIndex])
                }
            }
            newEmos.append(newSectionEmos)
        }
        return newEmos
    }
    
    // 添加空白表情
    fileprivate class func addEmptyEmotion(emotiions: [ChatEmotion]) -> [ChatEmotion] {
        var emos = emotiions
        let count = emos.count % 24
        if count == 0 {
            return emos
        }
        for _ in count..<23 {
            emos.append(ChatEmotion(isEmpty: true))
        }
        emos.append(ChatEmotion(isRemove: true))
        return emos
    }
    
    class func getImagePath(emotionName: String?) -> String? {
        if emotionName == nil {
            return nil
        }
        return Bundle.main.bundlePath + "/Expression.bundle/" + emotionName! + ".png"
    }
}
