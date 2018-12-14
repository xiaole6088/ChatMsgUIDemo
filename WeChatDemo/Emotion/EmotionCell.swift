//
//  EmotionCell.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/11.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

class EmotionCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    var emotion: ChatEmotion? {
        didSet {
            guard let emo = emotion else { return }
            if emo.isRemove {
                iconImageView.image = UIImage(named: "DeleteEmoticonBtn")
            } else if emo.isEmpty {
                iconImageView.image = UIImage()
            } else {
                guard let imgPath = emo.imgPath else {
                    return
                }
                iconImageView.image = UIImage(contentsOfFile: imgPath)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
