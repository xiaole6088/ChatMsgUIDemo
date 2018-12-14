//
//  ChatFindEmotion.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/10.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

class ChatFindEmotion: NSObject {
    // MARK:- 单例
    static let shared: ChatFindEmotion = ChatFindEmotion()
    
    // MARK: - 富文本转正常 string
    func textString(attrStr: NSAttributedString) -> String {
        let resultAtt = NSMutableAttributedString(attributedString: attrStr)
        attrStr.enumerateAttributes(in: NSRange(location: 0, length: attrStr.length), options: .reverse) { (attrs, range, stop) in
            if let textAtt: NSTextAttachment = attrs[NSAttributedString.Key.attachment] as? NSTextAttachment {
                
                if let image = textAtt.image {
                    let text = self.stringForImage(image: image)
                    resultAtt.replaceCharacters(in: range, with: text)
                }
            }
        }
        return resultAtt.string
    }
    
    private func stringForImage(image: UIImage) -> String {
        print(image)
        var imageName = ""
        let emotions = ChatEmotionHelper.getAllEmotions()
        let imageData = image.pngData()
        for emo in emotions where emo.imgPath != nil {
            if let image = UIImage(contentsOfFile: emo.imgPath!) {
                if image.pngData() == imageData {
                    imageName = emo.text ?? ""
                    print("匹配成功")
                }
            }
        }
        return imageName;
    }
    
    // MARK:- 查找属性字符串的方法
    func findAttrStr(text: String?, font: UIFont) -> NSMutableAttributedString? {
        guard let text = text else {
            return nil
        }
        
        let pattern = "\\[.*?\\]" // 匹配表情
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        let resutlts = regex.matches(in: text, options: [], range: NSMakeRange(0, text.count))
        
        //        let attrMStr = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.minimumLineHeight = font.pointSize
        
        let attrMStr = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : font,
                                                                            NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        for (_, result) in resutlts.enumerated().reversed() {
            let emoStr = (text as NSString).substring(with: result.range)
            guard let imgPath = findImgPath(emoStr: emoStr) else {
                return nil
            }
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: imgPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
        }
        return attrMStr
    }
    
    func findImgPath(emoStr: String) -> String? {
        for emotion in ChatEmotionHelper.getAllEmotions() {
            if emotion.text == emoStr {
                return emotion.imgPath
            }
        }
        return nil
    }
}
