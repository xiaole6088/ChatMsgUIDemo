//
//  TextTableViewCell.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/10.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

@objc protocol TextTableViewCellDelegate {
    func longPress(row: Int);
}

class TextTableViewCell: BaseTableViewCell {
    
    // MARK:- 模型
    override var model: ChatMsgModel? { didSet { setModel() } }
    weak var delegate: TextTableViewCellDelegate?
    // MARK:- 懒加载
    lazy var contentLabel: UILabel = {
        let contentL = UILabel()
        contentL.numberOfLines = 0
        contentL.textAlignment = .left
        contentL.font = UIFont.systemFont(ofSize: 16.0)
        return contentL
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bubbleView.addSubview(self.contentLabel)
        bubbleView.addSubview(self.userNameLabel)
        bubbleView.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(sender:)))
        bubbleView.addGestureRecognizer(longPress)
    }
    
    @objc func longPressAction(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            print("长按")
            self.becomeFirstResponder()
//            delegate?.longPress(row: 1)
            let menu = UIMenuController.shared
            let copyItem = UIMenuItem(title: "复制", action: #selector(copyItemClicked(menu:)))
            menu.menuItems = [copyItem]
            menu.setTargetRect(contentLabel.frame, in: bubbleView)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action ==  #selector(copyItemClicked(menu:)) {
            return true
        }
        return false
    }
    
    @objc func copyItemClicked(menu: UIMenuItem) {
        print("复制")
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

        // Configure the view for the selected state
    }
    
    static func staticCellHeight(model: ChatMsgModel, tableViewWidth: CGFloat) -> CGFloat {
        let contentL = UILabel()
        contentL.numberOfLines = 0
        contentL.textAlignment = .left
        contentL.font = UIFont.systemFont(ofSize: 16.0)
        contentL.attributedText = ChatFindEmotion.shared.findAttrStr(text: model.text, font: contentL.font)
        let contentSize = contentL.sizeThatFits(CGSize(width: 220.0, height: CGFloat(Float.greatestFiniteMagnitude)))
        
        var textHeight = contentSize.height
        
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
extension TextTableViewCell {
    
    fileprivate func setModel() {
        contentLabel.attributedText = ChatFindEmotion.shared.findAttrStr(text: model?.text, font: contentLabel.font)
        
        // 设置泡泡
        let img = self.model?.userType == .me ? #imageLiteral(resourceName: "message_sender_background_normal") : #imageLiteral(resourceName: "message_receiver_background_normal")
        let normalImg = img.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 28, bottom: 85, right: 28), resizingMode: .stretch)
        bubbleView.image = normalImg
        
        let contentSize = contentLabel.sizeThatFits(CGSize(width: 220.0, height: CGFloat(Float.greatestFiniteMagnitude)))
        
        if model?.showName == true {
            userNameLabel.isHidden = false
        } else {
            userNameLabel.isHidden = true
        }
        
        // 重新布局
        avatar.snp.remakeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(self.snp.top)
        }
        bubbleView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(-2)
            make.bottom.equalTo(contentLabel.snp.bottom).offset(12)
        }
        contentLabel.snp.remakeConstraints { (make) in
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
                make.left.equalTo(contentLabel.snp.left).offset(-20)
            }
            contentLabel.snp.makeConstraints { (make) in
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
                    make.bottom.equalTo(contentLabel.snp.bottom).offset(12)
                }
                userNameLabel.snp.remakeConstraints { (make) in
                    make.height.equalTo(userNameFrame.height)
                    make.width.equalTo(userNameFrame.width)
                }
                contentLabel.snp.remakeConstraints { (make) in
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
                    make.right.equalTo(contentLabel.snp.right).offset(20)
                }
                
                userNameLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(self.snp.top).offset(0)
                    make.left.equalTo(bubbleView.snp.left).offset(8)
                }
                contentLabel.snp.makeConstraints { (make) in
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
                    make.right.equalTo(contentLabel.snp.right).offset(20)
                }
                contentLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(bubbleView.snp.top).offset(12)
                    make.left.equalTo(bubbleView.snp.left).offset(17)
                }
                tipView.snp.makeConstraints { (make) in
                    make.left.equalTo(bubbleView.snp.right)
                }
            }
        }
        
        model?.cellHeight = getCellHeight()
    }
}
