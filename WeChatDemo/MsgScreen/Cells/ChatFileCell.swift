//
//  ChatFileCell.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/15.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

class ChatFileCell: BaseTableViewCell {
    // MARK:- 模型
    override var model: ChatMsgModel? { didSet { setModel() } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK:- 定义属性
    lazy var fileIcon: UIImageView = { [unowned self] in
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "sharemore_wallet")
        return icon
        }()
    
    lazy var fileNameLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
        }()
    
    lazy var fileSizeLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
        }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bubbleView.addSubview(self.fileIcon)
        bubbleView.addSubview(self.fileNameLabel)
        bubbleView.addSubview(self.fileSizeLabel)
        bubbleView.addSubview(self.userNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func staticCellHeight(model: ChatMsgModel, tableViewWidth: CGFloat) -> CGFloat {
        let contentHeight = 60
        if model.showName && model.userType != .me {
            let label = UILabel()
            label.numberOfLines = 1
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.text = model.fromUserId ?? "阿本"
            label.sizeToFit()
            let userNameFrame = label.frame
            return userNameFrame.size.height + CGFloat(contentHeight) + 10
        }
        return CGFloat(contentHeight) + 10
    }
    
}

extension ChatFileCell {
    fileprivate func setModel() {

        // 设置泡泡
        let img = self.model?.userType == .me ? #imageLiteral(resourceName: "message_sender_background_normal") : #imageLiteral(resourceName: "message_receiver_background_normal")
        let normalImg = img.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 28, bottom: 85, right: 28), resizingMode: .stretch)
        bubbleView.image = normalImg
    
        if model?.showName == true {
            userNameLabel.isHidden = false
        } else {
            userNameLabel.isHidden = true
        }
        
        fileNameLabel.text = model?.messageObjectFileName
        fileSizeLabel.text = String.fileSize(fileLength: model?.fileLength ?? 0)
        // 重新布局
        avatar.snp.remakeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(self.snp.top)
        }
        bubbleView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(-2)
            make.height.equalTo(60)
            make.width.lessThanOrEqualTo(240)
        }
        fileIcon.snp.remakeConstraints { (make) in
            make.width.height.equalTo(40)
            make.left.equalTo(bubbleView.snp.left).offset(10)
            make.top.equalTo(bubbleView.snp.top).offset(10)
        }
        
        fileNameLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(fileIcon.snp.right).offset(10)
            make.top.equalTo(bubbleView.snp.top).offset(10)
            make.right.equalTo(bubbleView.snp.right).offset(-17)
        }
        
        fileSizeLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(fileIcon.snp.right).offset(10)
            make.bottom.equalTo(bubbleView.snp.bottom).offset(-10)
            make.right.equalTo(bubbleView.snp.right).offset(-17)
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
            }
//            contentLabel.snp.makeConstraints { (make) in
//                make.top.equalTo(bubbleView.snp.top).offset(12)
//                make.right.equalTo(bubbleView.snp.right).offset(-17)
//            }
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
                }
//                userNameLabel.snp.remakeConstraints { (make) in
//                    make.height.equalTo(userNameFrame.height)
//                    make.width.equalTo(userNameFrame.width)
//                }
//                contentLabel.snp.remakeConstraints { (make) in
//                    make.height.equalTo(contentSize.height)
//                    make.width.equalTo(contentSize.width)
//                }
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
                }
//
//                userNameLabel.snp.makeConstraints { (make) in
//                    make.top.equalTo(self.snp.top).offset(0)
//                    make.left.equalTo(bubbleView.snp.left).offset(8)
//                }
//                contentLabel.snp.makeConstraints { (make) in
//                    make.top.equalTo(bubbleView.snp.top).offset(12)
//                    make.left.equalTo(bubbleView.snp.left).offset(17)
//                }
                tipView.snp.makeConstraints { (make) in
                    make.left.equalTo(bubbleView.snp.right)
                }
            } else {
                avatar.snp.makeConstraints { (make) in
                    make.left.equalTo(self.snp.left).offset(10)
                }
                
                bubbleView.snp.makeConstraints { (make) in
                    make.left.equalTo(avatar.snp.right).offset(2)
                }
//                contentLabel.snp.makeConstraints { (make) in
//                    make.top.equalTo(bubbleView.snp.top).offset(12)
//                    make.left.equalTo(bubbleView.snp.left).offset(17)
//                }
                tipView.snp.makeConstraints { (make) in
                    make.left.equalTo(bubbleView.snp.right)
                }
            }
        }
        
//        model?.cellHeight = getCellHeight()
    }
}
