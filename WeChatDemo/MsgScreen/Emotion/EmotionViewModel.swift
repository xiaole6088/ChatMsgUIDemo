//
//  EmotionViewModel.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/11.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

let itemWidth: CGFloat = 46
let insetMargin: CGFloat = 15

@objc protocol EmotionViewModelDelegate {
    func didSelectedEmotion(emo: ChatEmotion);
}

class EmotionViewModel: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: EmotionViewModelDelegate?
    weak var weakPageControl: UIPageControl?
    
    lazy var emotions: [[ChatEmotion]] = {
        return ChatEmotionHelper.getAllSectionEmotions(width: UIScreen.main.bounds.width)
    }()
    
    func getPageControlCount() -> Int {
        return emotions.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotions[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let emo = emotions[indexPath.section][indexPath.row]
        let cell: EmotionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmotionCell", for: indexPath) as! EmotionCell
        cell.emotion = emo
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let hCount = floor((collectionView.frame.width - (insetMargin * 2))/itemWidth)
        
        let vCount: CGFloat = 3.0
        
        let realWidth = (collectionView.frame.width - (insetMargin * 2))/hCount
        let realHeight = (collectionView.frame.height - (insetMargin * 2))/vCount
        
        return CGSize(width: realWidth, height: realHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: insetMargin, left: insetMargin, bottom: insetMargin, right: insetMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let emo = emotions[indexPath.section][indexPath.row]
        delegate?.didSelectedEmotion(emo: emo)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let page = contentOffset / scrollView.frame.size.width + (Int(contentOffset) % Int(scrollView.frame.size.width) == 0 ? 0 : 1)
        weakPageControl?.currentPage = Int(page)
    }

}
