//
import UIKit

class ChatAudioCell: BaseTableViewCell {
    
    // MARK:- 模型
    override var model: ChatMsgModel? { didSet { setModel() } }
    
    // MARK:- 定义属性
    lazy var voiceButton: UIButton = {
        let voiceBtn = UIButton(type: .custom)
        voiceBtn.setImage(#imageLiteral(resourceName: "message_voice_receiver_normal"), for: .normal)
        voiceBtn.imageView?.animationDuration = 1
        voiceBtn.imageEdgeInsets = UIEdgeInsets(top: -6, left: 0, bottom: 0, right: 0)
        voiceBtn.adjustsImageWhenHighlighted = false
        return voiceBtn
    }()
    lazy var durationLabel: UILabel = {
        let durationL = UILabel()
        durationL.font = UIFont.systemFont(ofSize: 12.0)
        durationL.text = "60\""
        durationL.textColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        return durationL
    }()
    
    // MARK:- init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(voiceButton)
        addSubview(durationLabel)
        
        // 添加事件
        voiceButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        // 注册通知
        // 音频播放完毕
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayEnd(_:)), name: NSNotification.Name(rawValue: kNoteChatMsgAudioPlayEnd), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 事件处理
extension ChatAudioCell {
    // MARK: 播放录音
    @objc fileprivate func playAudio() {
        // SDK 提供音频播放路径, 如果路径没有文件, 则下载音频 url 地址到路径里, 再播放音频
        guard let audioPath = model?.audioPath else {
            return
        }
        // 关闭播放
//        WeChatTools.shared.stopPlayVoice()
//        self.resetAudioAnimation()
        
//        if FileManager.isExists(at: audioPath) {
////            WeChatTools.shared.playVoice(with: audioPath)
//            voiceButton.imageView?.startAnimating()
//        } else {
//            NetworkTools.shared.download(urlStr: model?.audioUrl ?? "", savePath: audioPath, progress: nil, resultBlock: { [unowned self] (_, error) in
//                if error != nil {
//                    Log(error)
//                } else {
//                    WeChatTools.shared.playVoice(with: audioPath)
//                    DispatchQueue.main.async(execute: {
//                        self.voiceButton.imageView?.startAnimating()
//                    })
//                }
//            })
//        }
    }
    
    // MARK: 重置音频按钮动画(关闭动画)
    fileprivate func resetAudioAnimation() {
        voiceButton.imageView?.stopAnimating()
    }
    
    @objc fileprivate func audioPlayEnd(_ note: Notification) {
        let filePath = note.object as! String
        if filePath == model?.audioPath ?? "" {
            self.resetAudioAnimation()
        }
    }
}

// MARK:- 设置数据
extension ChatAudioCell {
    fileprivate func setModel() {
        guard let model = model else {
            return
        }
        model.cellHeight = 50
        
        durationLabel.text = "\(Int(ceil(model.audioDuration)))\""
        durationLabel.sizeToFit()
        var voiceWidth = 70 + 130 * CGFloat(model.audioDuration) / 60
        if voiceWidth > 200 { voiceWidth = 200 }
        
        // 设置泡泡
        let img = self.model?.userType == .me ? #imageLiteral(resourceName: "message_sender_background_normal") : #imageLiteral(resourceName: "message_receiver_background_normal")
        let normalImg = img.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 28, bottom: 85, right: 28), resizingMode: .stretch)
        bubbleView.image = normalImg
        
        // 重新布局
        avatar.snp.remakeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(self.snp.top)
        }
        voiceButton.snp.remakeConstraints { (make) in
            make.height.equalTo(35)
            make.width.equalTo(voiceWidth)
        }
        durationLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(25)
            make.width.equalTo(durationLabel.width)
            make.bottom.equalTo(voiceButton.snp.bottom)
        }
        bubbleView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(-2)
            make.bottom.equalTo(voiceButton.snp.bottom).offset(2)
        }
        tipView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(avatar.snp.centerY)
            make.width.height.equalTo(30)
        }
        
        if model.userType == .me {
            avatar.snp.makeConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(-10)
            }
            bubbleView.snp.makeConstraints { (make) in
                make.right.equalTo(avatar.snp.left).offset(-2)
                make.left.equalTo(voiceButton.snp.left).offset(-2)
            }
            voiceButton.snp.makeConstraints { (make) in
                make.top.equalTo(bubbleView.snp.top).offset(8)
                make.right.equalTo(bubbleView.snp.right).offset(-17)
            }
            tipView.snp.makeConstraints { (make) in
                make.right.equalTo(bubbleView.snp.left)
            }
            durationLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(bubbleView.snp.left).offset(-6)
            })
            
            voiceButton.setImage(#imageLiteral(resourceName: "message_voice_sender_normal"), for: .normal)
            voiceButton.imageView?.animationImages = [
                #imageLiteral(resourceName: "message_voice_sender_playing_1"),
                #imageLiteral(resourceName: "message_voice_sender_playing_2"),
                #imageLiteral(resourceName: "message_voice_sender_playing_3")
            ]
            voiceButton.contentHorizontalAlignment = .right
        } else {
            avatar.snp.makeConstraints { (make) in
                make.left.equalTo(self.snp.left).offset(10)
            }
            
            bubbleView.snp.makeConstraints { (make) in
                make.left.equalTo(avatar.snp.right).offset(2)
                make.right.equalTo(voiceButton.snp.right).offset(2)
            }
            voiceButton.snp.makeConstraints { (make) in
                make.top.equalTo(bubbleView.snp.top).offset(8)
                make.left.equalTo(bubbleView.snp.left).offset(17)
            }
            tipView.snp.makeConstraints { (make) in
                make.left.equalTo(bubbleView.snp.right)
            }
            durationLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(bubbleView.snp.right).offset(6)
            })
            
            voiceButton.setImage(#imageLiteral(resourceName: "message_voice_receiver_normal"), for: .normal)
            voiceButton.imageView?.animationImages = [
                #imageLiteral(resourceName: "message_voice_receiver_playing_1"),
                #imageLiteral(resourceName: "message_voice_receiver_playing_2"),
                #imageLiteral(resourceName: "message_voice_receiver_playing_3")
            ]
            voiceButton.contentHorizontalAlignment = .left
        }
    }
}
