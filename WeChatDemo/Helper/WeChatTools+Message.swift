//
//  WeChatTools+Message.swift
//  WeChat
//
//  Created by 林洵锋 on 2017/1/5.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import Foundation

enum WeChatMessageType {
    case audio
    case video
}

/*
class videoChatAttachment: NSObject, NIMCustomAttachment {
    // 0 : 视频   1 : 音频
    var videoType: Int = 1
    
    func encode() -> String {
        return "\(videoType)"
    }
}

// MARK:- 发送信息
extension WeChatTools {
    // MARK: 发送文本
    func sendText(userId: String?, text: String?) {
        guard let userId = userId else { return }
        let message = NIMMessage()
        message.text = text
        self.sendMessage(userId: userId, message: message)
    }
    // MARK: 发送图片
    func sendImage(userId: String?, image: UIImage) {
        guard let userId = userId else { return }
        let imageObj = NIMImageObject(image: image)
        let message = NIMMessage()
        message.messageObject = imageObj
        self.sendMessage(userId: userId, message: message)
    }
    // MARK: 发送音频/视频
    func sendMedia(userId: String?, filePath: String, type: WeChatMessageType) {
        guard let userId = userId else { return }
        let message = NIMMessage()
        switch type {
        case .audio:
            message.messageObject = NIMAudioObject(sourcePath: filePath)
        case .video:
            message.messageObject = NIMVideoObject(sourcePath: filePath)
        }
        self.sendMessage(userId: userId, message: message)
    }
    
    // MARK: 发送视频聊天
    func sendVideoChat(userId: String?) {
        guard let userId = userId else { return }
        let customObj = NIMCustomObject()
        let attachment = videoChatAttachment()
        customObj.attachment = attachment
        let message = NIMMessage()
        message.messageObject = customObj
        let session = NIMSession(userId, type: .P2P)
        
        guard ((try? NIMSDK.shared().chatManager.send(message, to: session)) != nil) else { return }
    }
    
    // MARK: 发送
    func sendMessage(userId: String, message: NIMMessage) {
//        let session = NIMSession.init(userId, type: .P2P)
//        guard let call = try? NIMSDK.shared().chatManager.send(message, to: session) else {
//            return
//        }
//        Log(call)
    }
}

// MARK:- NIMChatManagerDelegate
extension WeChatTools: NIMChatManagerDelegate {
    // MARK:- 发送消息的回调
    // MARK: 即将发送消息回调
    // 仅在收到这个回调后才将消息加入显示用的数据源中。
    func willSend(_ message: NIMMessage) {
        print("即将发送的信息")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:kNoteChatMsgInsertMsg), object: message)
    }
    // MARK: 消息发送进度回调
    // 图片，视频等需要上传附件的消息会有比较详细的进度回调，文本消息则没有这个回调。
    func send(_ message: NIMMessage, progress: CGFloat) {
        print("发送进度 --- \(progress)")
    }
    // MARK: 消息发送完毕回调
    // 如果消息发送成功 error 为 nil，反之 error 会被填充具体的失败原因
    internal func send(_ message: NIMMessage, didCompleteWithError error: Error?) {
        if error != nil {
            print(error)
        } else {
            print("消息发送成功")
        }
        // 通知更新状态
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:kNoteChatMsgUpdateMsg), object: message)
    }
    // MARK: 重发
    // 因为网络原因等导致的发送消息失败而需要重发的情况，直接调用
    // 此时如果再次调用 sendMessage，则会被 NIM SDK 认作新消息。
    func resendMessage(message: NIMMessage) -> Bool {
        guard (try? NIMSDK.shared().chatManager.resend(message)) != nil else {
            return false
        }
        // 通知更新状态
        // 会自动调用上面的 《消息发送完毕回调》
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:kNoteChatMsgResendMsg), object: message)
        return true

    }
    
    // MARK:- 接收消息
    // MARK: 收消息
    func onRecvMessages(_ messages: [NIMMessage]) {
        Log("收到消息")
        for msg in messages {
            if msg.from == currentChatUserId {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteChatMsgInsertMsg), object: msg)
            } else {
                Log("收到非当前聊天用户发来的消息")
            }
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteChatMsgInsertMsg), object: msg)
        }
    }
    // 如果收到的是图片，视频等需要下载附件的消息，在回调的处理中还需要调用（SDK 默认会在第一次收到消息时自动调用）
    // MARK: 附件的下载
    // 进行附件的下载，附件的下载过程会通过 这两个回调返回进度和结果。
    func fetchMessageAttachment(_ message: NIMMessage, progress: CGFloat) {
        print("进度： \(progress)")
    }
    
    func fetchMessageAttachment(_ message: NIMMessage, didCompleteWithError error: Error?) {
        print("结果")
        if error != nil {
            print(error)
        } else {
            print(message)
        }
    }
}
*/

// MARK:- 历史记录
extension WeChatTools {
    // MARK:- 从本地获取
    func getLocalMsgs(userId: String?, message: ImMessageModel? = nil) -> [ImMessageModel]? {
        guard let userId = userId else { return nil }
        var imModels: [ImMessageModel] = []
        for i in 0..<12 {
            let msg = ImMessageModel()
            msg.message = "测试测试测试[微笑]www.baidu.com[微笑]"
            msg.fromUserId = userId
            if i == 1 {
                msg.msgType = "image"
            } else if i == 2 {
                msg.msgType = "text"
            }
            imModels.append(msg)
        }
        
        for i in 0..<12 {
            let msg = ImMessageModel()
            msg.message = "15640921307"
            msg.fromUserId = WeChatTools.shared.getCurrentUserId()
            if i == 1 {
                msg.msgType = "image"
            } else if i == 2 {
                msg.msgType = "text"
            } else {
                msg.msgType = "text"
                msg.message = "测试测试测试测试测试测试[酷]测试测试测试测试测试测试测试测[微笑]试测试测试测试测试测试测试测试"
            }
            imModels.append(msg)
        }
        
        return imModels
        // sdk 取出来对话信息
        //        let session = NIMSession.init(userId, type: .P2P)
        //        return NIMSDK.shared().conversationManager.messages(in: session, message: message, limit: 10)
    }
    
    // MARK: 从云端获取
//    func getCloudMsgs(currentMessage: NIMMessage? = nil, userId: String?,  resultBlock: @escaping (Error?, [NIMMessage]?) -> ()) {
//        guard let userId = userId else { return }
//        let session = NIMSession.init(userId, type: .P2P)
//        let option = NIMHistoryMessageSearchOption()
//        //option.startTime = 0
//        option.endTime = currentMessage?.timestamp ?? 0
//        option.limit = 10
//        option.currentMessage = currentMessage
//        option.order = .desc // 检索倒序
//        option.sync = false  // 同步到本地(暂时设置为false，供测试)
//        NIMSDK.shared().conversationManager.fetchMessageHistory(session, option: option) { (error, messages) in
//            if messages != nil {
//                resultBlock(error, messages!.reversed())
//            } else {
//                resultBlock(error, messages)
//            }
//        }
//    }
//    
//    // MARK: 获取本地指定类型的消息
//    func searchLocalMsg(type:NIMMessageType = .image, userId: String?, resultBlock: @escaping (Error?, [NIMMessage]?) -> ()) {
//        guard let userId = userId else { return }
//        let session = NIMSession.init(userId, type: .P2P)
//        let option = NIMMessageSearchOption()
//        option.order = .asc
//        option.messageType = type
//        NIMSDK.shared().conversationManager.searchMessages(session, option: option) { (error, messages) in
//            resultBlock(error, messages)
//        }
//    }
}
