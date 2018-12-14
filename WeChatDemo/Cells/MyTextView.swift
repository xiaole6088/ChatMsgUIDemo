//
//  MyTextView.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/12.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

class MyTextView: UITextView {

    var realStr: String = ""
    var longPress: UILongPressGestureRecognizer?
    
    var canSelected: Bool = false
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.backgroundColor = UIColor.clear
        let menu = UIMenuController.shared
        let copyItem = UIMenuItem(title: "复制", action: #selector(copyItemClicked(menu:)))
        menu.menuItems = [copyItem]
        menu.setMenuVisible(false, animated: false)
        self.dataDetectorTypes = .all
        self.bounces = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideMenu), name: UIMenuController.didHideMenuNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willShowMenu(noti:)), name: UIMenuController.willShowMenuNotification, object: nil)
        self.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.isEditable = false
        //        contentT.isSelectable = false
        self.font = UIFont.systemFont(ofSize: 16.0)
    }
    
    func setFirstResponder() {
        self.canSelected = true
        self.becomeFirstResponder()
        self.selectAll(self)
    }
    
    func showMenu() {
        let menu = UIMenuController.shared
        let copyItem = UIMenuItem(title: "复制", action: #selector(copyItemClicked(menu:)))
        menu.menuItems = [copyItem]
        menu.setTargetRect(self.frame, in: self.superview!)
        menu.setMenuVisible(true, animated: true)
    }
    
    @objc func willShowMenu(noti: Notification)  {
        if self.isFirstResponder {
            print(noti.object)
//            self.selectAll(self)
        }
    }
    
    @objc func hideMenu()  {
        if self.isFirstResponder {
            self.resignFirstResponder()
        }
    }
    
    @objc func copyItemClicked(menu: UIMenuItem) {
        UIMenuController.shared.setMenuVisible(false, animated: false)
        self.resignFirstResponder()
        print(self.realStr)
        print("复制")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var canBecomeFirstResponder: Bool {
        print("canBecomeFirstResponder")
        return true
    }
    
    override var canResignFirstResponder: Bool {
        
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesCancelled")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
//        return true
        guard let pos = closestPosition(to: point) else { return false }
        
        guard let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: UITextDirection(rawValue: UITextLayoutDirection.left.rawValue)) else { return false }
        
        let startIndex = offset(from: beginningOfDocument, to: range.start)
        
        return attributedText.attribute(NSAttributedString.Key.link, at: startIndex, effectiveRange: nil) != nil
    }

}

extension MyTextView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
