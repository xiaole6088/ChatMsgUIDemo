//
//  ViewController.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/10.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

// MARK:- 通知常量
// 通讯录好友发生变化
let kNoteContactUpdateFriends  = "noteContactUpdateFriends"
// 添加消息
let kNoteChatMsgInsertMsg    = "noteChatMsgInsertMsg"
// 更新消息状态
let kNoteChatMsgUpdateMsg = "noteChatMsgUpdateMsg"
// 重发消息状态
let kNoteChatMsgResendMsg = "noteChatMsgResendMsg"
// 点击消息中的图片
let kNoteChatMsgTapImg = "noteChatMsgTapImg"
// 音频播放完毕
let kNoteChatMsgAudioPlayEnd = "noteChatMsgAudioPlayEnd"
// 视频开始播放
let kNoteChatMsgVideoPlayStart = "noteChatMsgVideoPlayStart"
/* ============================== 录音按钮长按事件 ============================== */
let kNoteChatBarRecordBtnLongTapBegan = "noteChatBarRecordBtnLongTapBegan"
let kNoteChatBarRecordBtnLongTapChanged = "noteChatBarRecordBtnLongTapChanged"
let kNoteChatBarRecordBtnLongTapEnded = "noteChatBarRecordBtnLongTapEnded"
/* ============================== 与网络交互后返回 ============================== */
let kNoteWeChatGoBack = "noteWeChatGoBack"

enum WeChatKeyboardType: Int {
    case noting
    case voice
    case text
    case emotion
    case more
}

let kChatBarOriginHeight: CGFloat = 49.0
let kChatBarTextViewMaxHeight: CGFloat = 100
let kChatBarTextViewHeight: CGFloat = kChatBarOriginHeight - 14.0

// MARK: Funcs
class ViewController: UIViewController {
    
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var keyboardHeight: CGFloat = 0.0
    
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var emojiView: UIView!
    var currentKeyboardType: WeChatKeyboardType = .noting
    @IBOutlet weak var inputTextView: CustomResponderTextView!
    @IBOutlet weak var barHeight: NSLayoutConstraint!
    var inputTextViewCurHeight: CGFloat = kChatBarOriginHeight
    
    @IBOutlet weak var emoPageControl: UIPageControl!
    @IBOutlet weak var emotionCollectionView: UICollectionView!
    var emotionViewModel: EmotionViewModel = EmotionViewModel()
    var msgViewModel: MsgListViewModel = MsgListViewModel()
    
    var menuIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bind()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.msgViewModel.firstSetDatas()
            self?.msgViewModel.scrollToBottom()
        }
    }
    
    func bind() {
        
        tableView.delegate = msgViewModel
        tableView.dataSource = msgViewModel
        msgViewModel.weakTableView = tableView
        msgViewModel.delegate = self
        msgViewModel.bind()
        
        inputTextView.delegate = self
        inputTextView.layer.cornerRadius = 4;
        inputTextView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.masksToBounds = true
        inputTextView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        emotionCollectionView.delegate = self.emotionViewModel
        emotionCollectionView.dataSource = self.emotionViewModel
        emotionCollectionView.register(UINib.init(nibName: "EmotionCell", bundle: nil), forCellWithReuseIdentifier: "EmotionCell")
        self.emotionViewModel.delegate = self;
        self.emotionViewModel.weakPageControl = self.emoPageControl
        self.emoPageControl.numberOfPages = emotionViewModel.getPageControlCount()
    }
    
    @objc private func handleKeyboardWillShow(notification: NSNotification) {
        UIMenuController.shared.menuItems = nil
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let value = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey)
        let keyboardRec = (value as AnyObject).cgRectValue
        var safeMargin: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            safeMargin = self.view.safeAreaInsets.bottom
        } else {
            safeMargin = self.bottomLayoutGuide.length
        }
        
        let height = keyboardRec?.size.height
        
        self.keyboardHeight = height ?? 0
        if let tmpH = height {
            UIView.animate(withDuration: CATransaction.animationDuration()) { [weak self] in
                guard let `self` = self else { return }
                self.bottomMargin.constant = -(tmpH - safeMargin)
                self.view.layoutIfNeeded()
                self.msgViewModel.scrollToBottom(animated: false, top: true)
            }
        }
    }
    
    @objc private func handleKeyboardWillHide(notification: NSNotification) {
        
        if self.bottomMargin.constant == 0 {
            return
        }
        if self.currentKeyboardType != .noting && self.currentKeyboardType != .text {
            return
        }
        
        UIView.animate(withDuration: CATransaction.animationDuration()) { [weak self] in
            guard let `self` = self else { return }
            self.bottomMargin.constant = 0
            self.view.layoutIfNeeded()
            self.msgViewModel.scrollToBottom(animated: true, top: false)
        }
    }
    
    func resetBarFrame() {
        if (self.currentKeyboardType == .more || self.currentKeyboardType == .emotion) && self.bottomMargin.constant != -220 {
            UIView.animate(withDuration: CATransaction.animationDuration()) { [weak self] in
                guard let `self` = self else { return }
                self.bottomMargin.constant = -220
                self.view.layoutIfNeeded()
                self.msgViewModel.scrollToBottom(animated: false, top: false)
            }
        } else if self.currentKeyboardType == .noting && self.bottomMargin.constant != 0 {
            UIView.animate(withDuration: CATransaction.animationDuration()) { [weak self] in
                guard let `self` = self else { return }
                self.bottomMargin.constant = 0
                self.view.layoutIfNeeded()
                self.msgViewModel.scrollToBottom(animated: false, top: false)
            }
        }
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        self.currentKeyboardType = .more
        self.inputTextView.resignFirstResponder()
        resetBarFrame()
        self.view.bringSubviewToFront(self.moreView)
    }
    
    @IBAction func emojiAction(_ sender: UIButton) {
        self.currentKeyboardType = .emotion
        self.inputTextView.resignFirstResponder()
        resetBarFrame()
        self.view.bringSubviewToFront(self.emojiView)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            refreshBarFrame()
        }
    }
    
    func refreshBarFrame() {
        var height = inputTextView.sizeThatFits(CGSize(width: inputTextView.width, height: CGFloat(Float.greatestFiniteMagnitude))).height
        height = height > kChatBarTextViewHeight ? height : kChatBarTextViewHeight
        height = height < kChatBarTextViewMaxHeight ? height : inputTextView.height
        let newHeight = height + kChatBarOriginHeight - kChatBarTextViewHeight
        
        if newHeight == self.barHeight.constant {
            return
        }
        inputTextViewCurHeight = newHeight
        UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
            // 调用代理方法
            self.barHeight.constant = self.inputTextViewCurHeight
            self.view.layoutIfNeeded()
            self.msgViewModel.scrollToBottom(animated: false, top: true)
        })
    }
    
    @IBAction func sendEmoAction(_ sender: UIButton) {
        sendCurrentInput()
    }
    
    func sendCurrentInput() {
        let new = ChatMsgModel()
        new.text = inputTextView.text
        new.modelType = .text
        new.userType = .me
        inputTextView.text = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.msgViewModel.insertNewMessage(new: new)
        }
    }
    
    deinit {
        inputTextView.removeObserver(self, forKeyPath: "contentSize")
    }
}

// MARK: UITextViewDelegate
extension ViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.currentKeyboardType == .text {
            self.currentKeyboardType = .noting
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.currentKeyboardType = .text
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        refreshBarFrame()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            print(textView.text)
           sendCurrentInput()
            return false
        }
        //删除
        if text.count == 0 && range.length == 1 {
            // 1.特殊情况长按调用系统UIMenuController只选择一个字符串删除
            if textView.selectedRange.length == 1 {
                return true
            }
            // 获取光标位置
            let loction = textView.selectedRange.location
            // 获取光标位置前的字符串
            let frontContent = NSString(string: textView.text).substring(to: loction)
            // 字符串以结尾比较,存在“]”
            if frontContent.hasSuffix("]") {
                return !deleteBackwardEmo()
            }
        }
        return true
    }
    
    func deleteBackwardEmo() -> Bool {
        // 获取光标位置
        var oldRange = inputTextView.selectedRange
        let loction = inputTextView.selectedRange.location
        print(loction)
        // 获取光标位置前的字符串
        let frontContent = NSString(string: inputTextView.text).substring(to: loction)
        // 字符串以结尾比较,存在“]”
        if frontContent.hasSuffix("]") {
            let lastRange = frontContent.nsRange(from: frontContent.range(of: "]", options: .backwards)!)
            if let firstRange = frontContent.range(of: "[", options: .backwards) {
                let nsrange = frontContent.nsRange(from: firstRange)
                let length = lastRange.location - nsrange.location + 1
                let targetRange = NSRange(location: nsrange.location, length: length)
                let subStr = (frontContent as NSString).substring(with: targetRange)
                print(subStr)
                if !ChatEmotionHelper.isEmotionStr(str: subStr) {
                    return false
                }
                let range = frontContent.range(from: targetRange)
                let new = inputTextView.text.replacingOccurrences(of: subStr, with: "", options: .backwards, range: range)
                inputTextView.text = new
                oldRange.location -= targetRange.length
                oldRange.length = 0
                if oldRange.location < 0 {
                    oldRange.location = 0
                }
                inputTextView.selectedRange = oldRange
                return true
            }
        }
        return false
    }
    
}

// MARK: EmotionViewModelDelegate
extension ViewController: EmotionViewModelDelegate {
    func didSelectedEmotion(emo: ChatEmotion) {
        if emo.isEmpty {
            return
        }
        if emo.isRemove {
            if !self.deleteBackwardEmo() {
                self.inputTextView.deleteBackward()
            }
            return
        }
        guard let text = emo.text else {
            return
        }
        self.inputTextView.text.append(text)
    }
}

// MARK: CellMenuItemActionDelegate
extension ViewController: CellMenuItemActionDelegate {

    func hideKeyboardView() {
        self.currentKeyboardType = .noting
        self.inputTextView.resignFirstResponder()
        resetBarFrame()
    }
    
    func willShowMenu(view: MyTextView, row: Int) {
        self.menuIndex = row
        if self.inputTextView.isFirstResponder {
            inputTextView.overrideNext = view
            // Observe "will hide" to do some cleanup
            // Do not use "did hide" which is not fast enough
            NotificationCenter.default.addObserver(self, selector: #selector(menuControllerWillHide), name: UIMenuController.willHideMenuNotification, object: nil)
        } else {
            view.becomeFirstResponder()
        }

        let menu = UIMenuController.shared
        let copyItem = UIMenuItem(title: "复制", action: #selector(menuItemCopyAction))
        let forwardItem = UIMenuItem(title: "转发", action: #selector(menuItemForwardAction))
        let deleteItem = UIMenuItem(title: "删除", action: #selector(menuItemDeleteAction))
        menu.menuItems = [copyItem, forwardItem, deleteItem]
        menu.setTargetRect(view.frame, in: view.superview!)
        menu.setMenuVisible(true, animated: true)
    }
    
//    func delete(msg: ChatMsgModel) {
//        print("删除这条消息")
//    }
//
//    func zhuanfa(text: String) {
//        let sb = UIStoryboard(name: "ZhuanFaViewController", bundle: nil)
//        let nav = sb.instantiateInitialViewController() as! UINavigationController
//        let vc = nav.viewControllers.first as! ZhuanFaViewController
//        let msg = ChatMsgModel()
//        msg.text = text
//        msg.modelType = .text
//        vc.zhuanfaMsg = msg
//        self.present(nav, animated: true, completion: nil)
//    }
    
    @objc private func menuControllerWillHide() {
        inputTextView.overrideNext = nil
        // Prevent custom menu items from displaying in text view
        UIMenuController.shared.menuItems = nil
        NotificationCenter.default.removeObserver(self, name: UIMenuController.willHideMenuNotification, object: nil)
    }
    
    @objc func menuItemCopyAction() {
        print("复制")
    }
    
    @objc func menuItemForwardAction() {

        print("转发")
        self.currentKeyboardType = .noting
        self.view.endEditing(true)
        self.inputTextView.resignFirstResponder()
        
        guard let indexRow = self.menuIndex else {
            return
        }
        print(indexRow)
        let sb = UIStoryboard(name: "ZhuanFaViewController", bundle: nil)
        let nav = sb.instantiateInitialViewController() as! UINavigationController
        let vc = nav.viewControllers.first as! ZhuanFaViewController
        let msg = ChatMsgModel()
        msg.text = self.msgViewModel.dataArr[indexRow].text
        msg.modelType = .text
        vc.zhuanfaMsg = msg
        self.menuIndex = nil
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func menuItemDeleteAction() {
        print("删除")
        self.currentKeyboardType = .noting
        self.view.endEditing(true)
        self.inputTextView.resignFirstResponder()
        
        guard let indexRow = self.menuIndex else {
            return
        }
        self.msgViewModel.deleteMessage(row: indexRow)
        print(indexRow)
        self.menuIndex = nil
    }
}
