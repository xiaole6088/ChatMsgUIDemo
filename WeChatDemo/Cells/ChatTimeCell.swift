//
//  ChatTimeCell.swift
//  WeChat
//
//  Created by 林洵锋 on 2017/1/8.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class ChatTimeCell: BaseTableViewCell {
    // MARK:- 模型
    override var model: ChatMsgModel? {
        didSet {
            setModel()
        }
    }
    // MARK:- 获取cell的高度
    override func getCellHeight() -> CGFloat {
        return 40.0
    }
    // MARK:- 懒加载
    lazy var timeLabel: UILabel = {
        let timeL = UILabel()
        timeL.textColor = UIColor.white
        timeL.font = UIFont.systemFont(ofSize: 12.0)
        return timeL
    }()
    
    lazy var bgView: UIView = {
        let bg = UIView()
        bg.layer.cornerRadius = 4
        bg.layer.masksToBounds = true
        bg.backgroundColor = #colorLiteral(red: 0.7450980392, green: 0.7450980392, blue: 0.7450980392, alpha: 0.6)
        return bg
    }()
    
    // MARK:- init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.addSubview(bgView)
        self.addSubview(timeLabel)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.left).offset(-4)
            make.top.equalTo(timeLabel).offset(-1)
            make.right.equalTo(timeLabel).offset(4)
            make.bottom.equalTo(timeLabel).offset(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatTimeCell {
    fileprivate func setModel() {
        guard let model = model else {
            return
        }
        model.cellHeight = 40
        
//        timeLabel.text = ChatMsgTimeHelper.shared.chatTimeString(with: model.time)
        timeLabel.text = "2018-01-01 15:00"
        timeLabel.sizeToFit()
        timeLabel.snp.remakeConstraints { (make) in
            make.width.equalTo(timeLabel.width)
            make.height.equalTo(timeLabel.height)
            make.center.equalTo(self.snp.center)
        }
    }
}
