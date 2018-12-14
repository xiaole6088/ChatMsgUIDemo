//
//  ChatTextViewCell.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/12.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

class ChatTextViewCell: BaseTableViewCell {
    
    // MARK:- 模型
    override var model: ChatMsgModel? { didSet { setModel() } }
    weak var delegate: CellMenuItemActionDelegate?
    var longPress: UILongPressGestureRecognizer?
//    var menuController = UIMenuController.init()
    // MARK:- 懒加载
    lazy var contentTextView: MyTextView = {
        let contentT = MyTextView(frame: CGRect(x: 0, y: 0, width: 0, height: 20), textContainer: nil)
        return contentT
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bubbleView.addSubview(self.contentTextView)
        bubbleView.addSubview(self.userNameLabel)
        bubbleView.isUserInteractionEnabled = true
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(sender:)))
        longPress?.delegate = self
        bubbleView.addGestureRecognizer(longPress!)
        
        bubbleView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

    }
    
    @objc func longPressAction(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            let location = sender.location(in: contentTextView)
            if contentTextView.point(inside: location, with: nil) {
                return
            }
            print("长按")
//            contentTextView.setFirstResponder()
//            contentTextView.showMenu()
//            if bubbleView.gestureRecognizers?.contains(longPress!) == true {
//                bubbleView.removeGestureRecognizer(longPress!)
//            }
            self.delegate?.willShowMenu(view: contentTextView, row: self.row)
//            self.becomeFirstResponder()
//            let menu = UIMenuController.shared
//            let copyItem = UIMenuItem(title: "复制", action: #selector(menuItemAction))
//            menu.menuItems = [copyItem]
//            menu.setTargetRect(contentTextView.frame, in: bubbleView)
//            menu.setMenuVisible(true, animated: true)
        }
    }
    
    @objc func menuItemCopyAction() {
        UIPasteboard.general.string = self.contentTextView.realStr
    }
    
//    @objc func menuItemForwardAction() {
//        self.delegate?.zhuanfa(text: self.contentTextView.realStr)
//    }
//    
//    @objc func menuItemDeleteAction() {
//        guard let msg = self.model else {
//            return
//        }
//        self.delegate?.delete(msg: msg)
//    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action ==  #selector(menuItemCopyAction) {
            return true
        }
//        if action == #selector(menuItemForwardAction) {
//            return true
//        }
//        if action == #selector(menuItemDeleteAction) {
//            return true
//        }
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == longPress {
            let location = gestureRecognizer.location(in: contentTextView)
            return !contentTextView.point(inside: location, with: nil)
        }
        return true
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        self.menuController.setMenuVisible(true, animated: true)
        // Configure the view for the selected state
    }
    
    static func staticCellHeight(model: ChatMsgModel, tableViewWidth: CGFloat) -> CGFloat {
        let contentL = MyTextView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 300), textContainer: nil)
        contentL.attributedText = ChatFindEmotion.shared.findAttrStr(text: model.text, font: contentL.font!)
        let contentSize = contentL.sizeThatFits(CGSize(width: 220.0, height: CGFloat(Float.greatestFiniteMagnitude)))
        var textHeight = ceil(contentSize.height)
        
        if textHeight + 24 < 40 {
            textHeight = 40
        }
        
        if model.showName && model.userType != .me {
            let label = UILabel()
            label.numberOfLines = 1
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.text = model.fromUserId ?? "阿本"
            label.sizeToFit()
            let userNameFrame = label.frame
            return userNameFrame.size.height + 12 + textHeight + 12 + 10
        }
        
        return 12 + textHeight + 12 + 10
    }
}


// MARK:- 模型数据
extension ChatTextViewCell {
    
    fileprivate func setModel() {
//        contentTextView.font = UIFont.systemFont(ofSize: 16.0)
        contentTextView.attributedText = ChatFindEmotion.shared.findAttrStr(text: model?.text, font: UIFont.systemFont(ofSize: 16.0) )
        contentTextView.realStr = model?.text ?? ""
        let contentSize = contentTextView.sizeThatFits(CGSize(width: 220.0, height: CGFloat(Float.greatestFiniteMagnitude)))
        
        // 设置泡泡
        let img = self.model?.userType == .me ? #imageLiteral(resourceName: "message_sender_background_normal") : #imageLiteral(resourceName: "message_receiver_background_normal")
        let normalImg = img.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 28, bottom: 85, right: 28), resizingMode: .stretch)
        bubbleView.image = normalImg
        
        contentTextView.contentSize = contentSize

        if model?.showName == true {
            userNameLabel.isHidden = false
        } else {
            userNameLabel.isHidden = true
        }
        
//        // 重新布局
        avatar.snp.remakeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(self.snp.top)
        }
        bubbleView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(-2)
            make.bottom.equalTo(contentTextView.snp.bottom).offset(12)
        }
        contentTextView.snp.remakeConstraints { (make) in
            make.height.equalTo(contentSize.height)
            make.width.equalTo(contentSize.width)
        }
        tipView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(avatar.snp.centerY)
            make.width.height.equalTo(30)
        }

        if model?.userType == .me {
            avatar.snp.makeConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(-10)
            }
            bubbleView.snp.makeConstraints { (make) in
                make.right.equalTo(avatar.snp.left).offset(-2)
                make.left.equalTo(contentTextView.snp.left).offset(-15)
            }
            contentTextView.snp.makeConstraints { (make) in
                make.top.equalTo(bubbleView.snp.top).offset(12)
                make.right.equalTo(bubbleView.snp.right).offset(-17)
            }
            tipView.snp.makeConstraints { (make) in
                make.right.equalTo(bubbleView.snp.left)
            }

        } else {

            if model?.showName == true {
                userNameLabel.text = model?.fromUserId ?? "阿本"
                userNameLabel.sizeToFit()
                let userNameFrame = userNameLabel.frame
                // 重新布局
                avatar.snp.remakeConstraints { (make) in
                    make.width.height.equalTo(40)
                    make.top.equalTo(self.snp.top)
                }
                bubbleView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.snp.top).offset(userNameFrame.height-2)
                    make.bottom.equalTo(contentTextView.snp.bottom).offset(12)
                }
                userNameLabel.snp.remakeConstraints { (make) in
                    make.height.equalTo(userNameFrame.height)
                    make.width.equalTo(userNameFrame.width)
                }
                contentTextView.snp.remakeConstraints { (make) in
                    make.height.equalTo(contentSize.height)
                    make.width.equalTo(contentSize.width)
                }
                tipView.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(avatar.snp.centerY)
                    make.width.height.equalTo(30)
                }
                //
                avatar.snp.makeConstraints { (make) in
                    make.left.equalTo(self.snp.left).offset(10)
                }

                bubbleView.snp.makeConstraints { (make) in
                    make.left.equalTo(avatar.snp.right).offset(2)
                    make.right.equalTo(contentTextView.snp.right).offset(15)
                }

                userNameLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(self.snp.top).offset(0)
                    make.left.equalTo(bubbleView.snp.left).offset(8)
                }
                contentTextView.snp.makeConstraints { (make) in
                    make.top.equalTo(bubbleView.snp.top).offset(12)
                    make.left.equalTo(bubbleView.snp.left).offset(17)
                }
                tipView.snp.makeConstraints { (make) in
                    make.left.equalTo(bubbleView.snp.right)
                }
            } else {
                avatar.snp.makeConstraints { (make) in
                    make.left.equalTo(self.snp.left).offset(10)
                }

                bubbleView.snp.makeConstraints { (make) in
                    make.left.equalTo(avatar.snp.right).offset(2)
                    make.right.equalTo(contentTextView.snp.right).offset(15)
                }
                contentTextView.snp.makeConstraints { (make) in
                    make.top.equalTo(bubbleView.snp.top).offset(12)
                    make.left.equalTo(bubbleView.snp.left).offset(17)
                }
                tipView.snp.makeConstraints { (make) in
                    make.left.equalTo(bubbleView.snp.right)
                }
            }
        }
//        print(contentTextView.contentSize.height)
//        model?.cellHeight = getCellHeight()
    }
}
