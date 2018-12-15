//
//  MoreActionHelper.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/14.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

class MoreActionHelper: NSObject {
    
    // MARK:- 获取方法数组
    class func getAllSelectors() -> [ChatSelectorModel] {
        var selectors: [ChatSelectorModel] = []
        
        // 选取照片
        let picture = ChatSelectorModel()
        picture.text = "照片"
        picture.imageName = "sharemore_pic"
        selectors.append(picture)
        // 拍照
        let camera = ChatSelectorModel()
        camera.text = "拍摄"
        camera.imageName = "sharemore_video"
        selectors.append(camera)
        
        // 文件
        let file = ChatSelectorModel()
        file.text = "文件"
        file.imageName = "sharemore_wallet"
        selectors.append(file)
        
        return selectors
    }
    
    class func getSectionSelectors(width: CGFloat) -> [[ChatSelectorModel]] {
        let hCount = 4
        let vCount = 2
        let itemCount = hCount * vCount
        let array = MoreActionHelper.getAllSelectors()
        let pageCount: Int = array.count / 8 + 1
        var index = 0
        var newSelectors: [[ChatSelectorModel]] = []
        for _ in 0..<pageCount {
            var sections: [ChatSelectorModel] = []
            for _ in 0..<itemCount {
                if index < array.count {
                    // 真selector
                    sections.append(array[index])
                    index += 1
                } else {
                    // 空白selector
                    let empty = ChatSelectorModel()
                    empty.isEmpty = true
                    sections.append(empty)
                }
            }
            
            var newSections: [ChatSelectorModel] = []
            for i in 0..<hCount {
                for j in 0..<vCount {
                    let newIndex = j * hCount + i
                    newSections.append(sections[newIndex])
                }
            }
            newSelectors.append(newSections)
        }
        return newSelectors
    }
}
