//
//  ChatMsgDataHelper.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/10.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

let kChatMsgImgMaxWidth: CGFloat = 125 //最大的图片宽度
let kChatMsgImgMinWidth: CGFloat = 50 //最小的图片宽度
let kChatMsgImgMaxHeight: CGFloat = 150 //最大的图片高度
let kChatMsgImgMinHeight: CGFloat = 50 //最小的图片高度

class ChatMsgDataHelper: NSObject {
    static let shared: ChatMsgDataHelper = ChatMsgDataHelper()
    
    func getThumbImageSize(_ originalSize: CGSize) -> CGSize {
        let imgRealHeight = originalSize.height
        let imgRealWidth = originalSize.width
        
        var resizeThumbWidth: CGFloat
        var resizeThumbHeight: CGFloat
        
        /**
         *  如果图片的高度 >= 图片的宽度 , 高度就是最大的高度，宽度等比
         *  如果图片的高度 < 图片的宽度 , 以宽度来做等比，算出高度
         */
        if imgRealHeight >=  imgRealWidth {
            let scaleWidth = imgRealWidth * kChatMsgImgMaxHeight / imgRealHeight
            resizeThumbWidth = (scaleWidth > kChatMsgImgMinWidth) ? scaleWidth : kChatMsgImgMinWidth
            resizeThumbHeight = kChatMsgImgMaxHeight
        } else {
            let scaleHeight = imgRealHeight * kChatMsgImgMaxWidth / imgRealWidth
            resizeThumbHeight = (scaleHeight > kChatMsgImgMinHeight) ? scaleHeight : kChatMsgImgMinHeight
            resizeThumbWidth = kChatMsgImgMaxWidth
        }
        
        return CGSize(width: resizeThumbWidth, height: resizeThumbHeight)
    }
}

// MARK:- 获取格式化消息
extension ChatMsgDataHelper {
    func getFormatMsgs(nimMsgs: [ImMessageModel]?) -> [ChatMsgModel] {
        var formatMsgs: [ChatMsgModel] = [ChatMsgModel]()
        guard let nimMsgs = nimMsgs else { return formatMsgs }
        for nimMsg in nimMsgs {
            let model = ChatMsgModel()
            model.message = nimMsg
            formatMsgs.append(model)
        }
        return formatMsgs
    }
}

// MARK:- 获取图片消息数组
extension ChatMsgDataHelper {
    func getImgMsgs(msgModels: [ChatMsgModel]) -> [ChatMsgModel] {
        var newMsgModels = [ChatMsgModel]()
        for msgModel in msgModels {
            if msgModel.modelType == .image {
                newMsgModels.append(msgModel)
            }
        }
        return newMsgModels
    }
}

// MARK:- 数组添加时间
extension ChatMsgDataHelper {
    
    func getCellHeights(models: [ChatMsgModel]) -> [CGFloat] {
        var heights: [CGFloat] = []
        for model in models {
            if model.modelType == .text {
                let height = ChatTextViewCell.staticCellHeight(model: model, tableViewWidth: UIScreen.main.bounds.width)
                heights.append(height)
            } else if model.modelType == .image {
                let height = ChatImageCell.staticCellHeight(model: model, tableViewWidth: UIScreen.main.bounds.width)
                heights.append(height)
            } else if model.modelType == .file {
                let height = ChatFileCell.staticCellHeight(model: model, tableViewWidth: UIScreen.main.bounds.width)
                heights.append(height)
            } else {
                heights.append(40)
            }
        }
        return heights
    }
    
    // MARK: 为聊天记录数组添加时间
    // 给历史记录数组使用
    func addTimeModel(finalModel: ChatMsgModel? = nil, models: [ChatMsgModel]) -> [ChatMsgModel] {
        var myModels = [ChatMsgModel]()
        for index in 0..<models.count {
            if index == 0 { // 第一条
                if finalModel == nil {
                    // 直接添加 时间模型
                    myModels.append(createTimeModel(model: models[index]))
                } else {
//                    if ChatMsgTimeHelper.shared.needAddMinuteModel(preModel: finalModel!, curModel: models[index]) {
//                        myModels.append(createTimeModel(model: models[index]))
//                    }
                }
            } else {
                // 是否相差五分钟，是则添加
//                if ChatMsgTimeHelper.shared.needAddMinuteModel(preModel: models[index - 1], curModel: models[index]) {
//                    myModels.append(createTimeModel(model: models[index]))
//                }
            }
            myModels.append(models[index])
        }
        return myModels
    }
    
    // MARK: 创建时间模型
    fileprivate func createTimeModel(model: ChatMsgModel) -> ChatMsgModel {
        let timeModel: ChatMsgModel = ChatMsgModel()
        timeModel.message = model.message
        timeModel.modelType = .time
        timeModel.time = model.time
//        timeModel.timeStr = ChatMsgTimeHelper.shared.chatTimeString(with: timeModel.time)
        timeModel.timeStr = "2018-02-02"
        return timeModel
    }
}
