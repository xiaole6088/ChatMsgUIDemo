//
//  BaseTableViewCell.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/10.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit
import SnapKit

class BaseTableViewCell: UITableViewCell {
    
    var row: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK:- 模型
    var model: ChatMsgModel? {
        didSet {
            baseCellSetModel()
        }
    }
    
    // MARK:- 获取cell的高度
    func getCellHeight() -> CGFloat {
    
        self.layoutSubviews()
        
        if avatar.frame.size.height > bubbleView.frame.size.height {
            return avatar.frame.size.height + 10.0
        } else {
            return bubbleView.frame.size.height + 10.0
        }
    }
    
    lazy var avatar: UIButton = {
        let avaBtn = UIButton()
        avaBtn.setImage(#imageLiteral(resourceName: "Icon"), for: .normal)
        return avaBtn
    }()
    
    lazy var bubbleView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var tipView: UIView = { [unowned self] in
        let tipV = UIView()
        tipV.addSubview(self.activityIndicator)
        tipV.addSubview(self.resendButton)
        return tipV
        }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView()
        act.style = .gray
        act.hidesWhenStopped = false
        act.startAnimating()
        return act
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return label
    }()
    
    lazy var resendButton: UIButton = {
        let resendBtn = UIButton(type: .custom)
        resendBtn.setImage(#imageLiteral(resourceName: "resend"), for: .normal)
        resendBtn.contentMode = .scaleAspectFit
        resendBtn.addTarget(self, action: #selector(resend), for: .touchUpInside)
        return resendBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        self.addSubview(avatar)
        self.addSubview(bubbleView)
        self.addSubview(tipView)
        
        activityIndicator.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(tipView)
        }
        resendButton.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(tipView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BaseTableViewCell {

    @objc func resend() {
        print("重新发送操作")
        guard let message = model?.message else {
            return
        }
        // MARK: 重发
        // 因为网络原因等导致的发送消息失败而需要重发的情况，直接调用
        // 此时如果再次调用 sendMessage，则会被 NIM SDK 认作新消息。
        
//        if WeChatTools.shared.resendMessage(message: message) {
//            ("重送发送成功")
//        } else {
//            ("重送发送成失败")
//        }
    }
}

extension BaseTableViewCell {
    func baseCellSetModel() {
        tipView.isHidden = false
        activityIndicator.startAnimating()

        // sdk: 消息送达状态枚举
//        guard let deliveryState = model?.message?.deliveryState else {
//            return
//        }
        if model?.userType == .me { // 自己
            tipView.isHidden = true
            
//            switch deliveryState {
//            case .delivering:
//                resendButton.isHidden = true
//                activityIndicator.isHidden = false
//            case .failed:
//                resendButton.isHidden = false
//                activityIndicator.isHidden = true
//            case .deliveried:
//                tipView.isHidden = true
//            }
        } else {    // 对方
            tipView.isHidden = true
        }
    }
}
