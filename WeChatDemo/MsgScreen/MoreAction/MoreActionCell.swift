//
//  MoreActionCell.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/14.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

class MoreActionCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    var click:((String)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btn.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        btn.layer.cornerRadius = 6
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
    }

    var selector: ChatSelectorModel? {
        didSet {
            guard let sel = selector else { return }
            if sel.isEmpty {
                btn.isHidden = true
                label.isHidden = true
            } else {
                guard let imageName = sel.imageName else {
                    return
                }
                btn.isHidden = false
                label.isHidden = false
                btn.setImage(UIImage(named: imageName), for: .normal)
                label.text = sel.text
            }
        }
    }
    
    @IBAction func clickAction(_ sender: UIButton) {
        self.click?(self.label.text ?? "")
    }
}
