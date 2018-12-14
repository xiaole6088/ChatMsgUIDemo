
import UIKit

class ChatImageCell: BaseTableViewCell {
    
    // MARK:- 模型
    override var model: ChatMsgModel? { didSet { setModel() } }
    
    // MARK:- 定义属性
    lazy var chatImgView: UIImageView = { [unowned self] in
        let chatImgV = UIImageView()
        // 添加手势
        chatImgV.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(imgTap))
        chatImgV.addGestureRecognizer(tapGes)
        return chatImgV
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        bubbleView.addSubview(self.chatImgView)
        bubbleView.addSubview(self.userNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- 手势处理
extension ChatImageCell {
    @objc fileprivate func imgTap() {
        let objDic = ["model": model!, "view": chatImgView] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteChatMsgTapImg), object: objDic)
    }
}


// MARK:- 设置数据
extension ChatImageCell {
    
    static func staticCellHeight(model: ChatMsgModel, tableViewWidth: CGFloat) -> CGFloat {
        
        let imageSize = #imageLiteral(resourceName: "image").size
        // 获取缩略图size
        let thumbSize = ChatMsgDataHelper.shared.getThumbImageSize(imageSize)
        
        var imageHeight = thumbSize.height
        if imageHeight < 40 {
            imageHeight = 40
        }
        
        if model.showName && model.userType != .me {
            let label = UILabel()
            label.numberOfLines = 1
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.text = model.fromUserId ?? "阿本"
            label.sizeToFit()
            let userNameFrame = label.frame
            return userNameFrame.size.height + imageHeight + 10
        }
        
        return imageHeight + 10
    }
    
    fileprivate func setModel() {
        if subviews.contains(chatImgView) {
            chatImgView.removeFromSuperview()
        }
        addSubview(chatImgView)
        
        chatImgView.image = #imageLiteral(resourceName: "image")
        
        let imageSize = #imageLiteral(resourceName: "image").size
        // 获取缩略图size
        let thumbSize = ChatMsgDataHelper.shared.getThumbImageSize(imageSize)
        
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
        chatImgView.snp.remakeConstraints { (make) in
            make.top.equalTo(avatar.snp.top)
            make.width.equalTo(thumbSize.width)
            make.height.equalTo(thumbSize.height)
        }
        bubbleView.snp.remakeConstraints { (make) in
            make.left.top.right.bottom.equalTo(chatImgView)
        }
        tipView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(avatar.snp.centerY)
            make.width.height.equalTo(30)
        }
        
        if model?.userType == .me {
            avatar.snp.makeConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(-10)
            }
            chatImgView.snp.makeConstraints { (make) in
                make.right.equalTo(avatar.snp.left).offset(-2)
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
                chatImgView.snp.remakeConstraints { (make) in
                    make.top.equalTo(avatar.snp.top).offset(userNameFrame.height)
                    make.width.equalTo(thumbSize.width)
                    make.height.equalTo(thumbSize.height)
                }
                userNameLabel.snp.remakeConstraints { (make) in
                    make.height.equalTo(userNameFrame.height)
                    make.width.equalTo(userNameFrame.width)
                }
                bubbleView.snp.remakeConstraints { (make) in
                    make.left.top.right.bottom.equalTo(chatImgView)
                }
                tipView.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(avatar.snp.centerY)
                    make.width.height.equalTo(30)
                }
                //
                userNameLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(self.snp.top).offset(0)
                    make.left.equalTo(bubbleView.snp.left).offset(8)
                }
                avatar.snp.makeConstraints { (make) in
                    make.left.equalTo(self.snp.left).offset(10)
                }
                chatImgView.snp.makeConstraints { (make) in
                    make.left.equalTo(avatar.snp.right).offset(2)
                }
                tipView.snp.makeConstraints { (make) in
                    make.left.equalTo(bubbleView.snp.right)
                }
                
            } else {
                avatar.snp.makeConstraints { (make) in
                    make.left.equalTo(self.snp.left).offset(10)
                }
                chatImgView.snp.makeConstraints { (make) in
                    make.left.equalTo(avatar.snp.right).offset(2)
                }
                tipView.snp.makeConstraints { (make) in
                    make.left.equalTo(bubbleView.snp.right)
                }
            }
            
        }
        
        model?.cellHeight = getCellHeight()
        
        // 绘制 imageView 的 bubble layer
        let stretchInsets = UIEdgeInsets(top: 30, left: 28, bottom: 23, right: 28)
        let stretchImage = model?.userType == .me ? #imageLiteral(resourceName: "SenderImageNodeMask") : #imageLiteral(resourceName: "ReceiverImageNodeMask")
        self.chatImgView.clipShape(stretchImage: stretchImage, stretchInsets: stretchInsets)

        // 绘制coerImage 盖住图片
        let stretchCoverImage = model?.userType == .me ? #imageLiteral(resourceName: "SenderImageNodeBorder") : #imageLiteral(resourceName: "ReceiverImageNodeBorder")
        let bubbleCoverImage = stretchCoverImage.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        bubbleView.image = bubbleCoverImage
        
    }
}

