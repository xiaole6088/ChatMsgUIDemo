//
//  MoreActionViewModel.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/14.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

@objc protocol MoreSelectorDelegate {
    func chosePicture()
    func takePhoto()
    func sendFile()
}

class MoreActionViewModel: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    weak var weakPageControl: UIPageControl?
    weak var delegate: MoreSelectorDelegate?
    
    lazy var selectors: [[ChatSelectorModel]] = {
        return MoreActionHelper.getSectionSelectors(width: UIScreen.main.bounds.width)
    }()
    
    func getPageControlCount() -> Int {
        return selectors.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return selectors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectors[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sel = selectors[indexPath.section][indexPath.row]
        let cell: MoreActionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreActionCell", for: indexPath) as! MoreActionCell
        cell.click = { [weak self] text in
            self?.handleAction(title: text)
        }
        cell.selector = sel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin = (collectionView.frame.width - 240) / 5
        return UIEdgeInsets(top: 20, left: margin, bottom: 0, right: margin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView.frame.width - 240) / 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let vCount = 2
        
        let realWidth: CGFloat = 60
        let realHeight = (collectionView.frame.height - 20) / CGFloat(vCount)
        
        return CGSize(width: realWidth, height: realHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func handleAction(title: String) {
        if title == "拍摄" {
            self.delegate?.takePhoto()
        } else if title == "照片" {
            self.delegate?.chosePicture()
        } else if title == "文件" {
            self.delegate?.sendFile()
        }
    }
}
