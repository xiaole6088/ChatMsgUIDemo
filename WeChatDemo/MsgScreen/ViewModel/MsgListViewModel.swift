//
//  MsgListViewModel.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/13.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

// cellID
fileprivate let ChatTextCellID = "ChatTextCellID"
fileprivate let ChatTextViewCellID = "ChatTextViewCellID"
fileprivate let ChatImageCellID = "ChatImageCellID"
fileprivate let ChatTimeCellID = "ChatTimeCellID"
fileprivate let ChatFileCellID = "ChatFileCellID"
fileprivate let ChatAudioCellID = "ChatAudioCellID"
fileprivate let ChatVideoCellID = "ChatVideoCellID"

@objc protocol CellMenuItemActionDelegate {
    func willShowMenu(view: MyTextView, row: Int)
    func hideKeyboardView()
//    func zhuanfa(text: String)
//    func delete(msg: ChatMsgModel)
}

class MsgListViewModel: NSObject, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var heightArr: [CGFloat] = []
    var dataArr: [ChatMsgModel] = []
    weak var delegate: CellMenuItemActionDelegate?
    weak var weakTableView: UITableView?
    func bind() {
        weakTableView?.register(TextTableViewCell.classForCoder(), forCellReuseIdentifier: ChatTextCellID)
        weakTableView?.register(ChatImageCell.classForCoder(), forCellReuseIdentifier: ChatImageCellID)
        weakTableView?.register(ChatTimeCell.classForCoder(), forCellReuseIdentifier: ChatTimeCellID)
        weakTableView?.register(ChatTextViewCell.classForCoder(), forCellReuseIdentifier: ChatTextViewCellID)
        weakTableView?.register(ChatFileCell.classForCoder(), forCellReuseIdentifier: ChatFileCellID)
        weakTableView?.estimatedRowHeight = 0
        weakTableView?.estimatedSectionFooterHeight = 0
        weakTableView?.estimatedSectionHeaderHeight = 0
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadOldMessages), for: .valueChanged)
        weakTableView?.refreshControl = refreshControl
    }
    
    func firstSetDatas() {
        let history = WeChatTools.shared.getLocalMsgs(userId: "聊天人员的 id")
        let models = ChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: history)
        let newDatas = ChatMsgDataHelper.shared.addTimeModel(models: models)
        self.dataArr = newDatas
        self.heightArr = ChatMsgDataHelper.shared.getCellHeights(models: newDatas)
        self.weakTableView?.reloadData()
        self.weakTableView?.layoutIfNeeded()
    }
    
    func scrollToBottom(animated: Bool = false, top: Bool = false) {
        self.weakTableView?.layoutIfNeeded()
        if dataArr.count > 0 {
            if top {
                weakTableView?.scrollToRow(at: IndexPath(row: dataArr.count - 1, section: 0), at: .top, animated: animated)
            } else {
                weakTableView?.scrollToRow(at: IndexPath(row: dataArr.count - 1, section: 0), at: .bottom, animated: animated)
            }
        }
    }
    
    @objc func reloadOldMessages() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let `self` = self else {
                return
            }
            self.weakTableView?.refreshControl?.endRefreshing()
            self.insertRowModel(model: self.moreOldMsgs(), isBottom: false)
        }
    }
    
    func moreOldMsgs() -> [ChatMsgModel] {
        let history = WeChatTools.shared.getLocalMsgs(userId: "聊天人员的 id")
        let models = ChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: history)
        let newDatas = ChatMsgDataHelper.shared.addTimeModel(models: models)
        return newDatas.reversed()
    }
    
    func insertNewMessage(new: ChatMsgModel) {
        insertRowModel(model: [new], isBottom: true)
    }
    
    func deleteMessage(row: Int) {
        if dataArr.count > row {
            dataArr.remove(at: row)
            heightArr.remove(at: row)
            weakTableView?.reloadData()
        }
    }
    
    // MARK: 插入模型数据
    func insertRowModel(model: [ChatMsgModel], isBottom: Bool = true) {
        if isBottom {
            let newHeights = ChatMsgDataHelper.shared.getCellHeights(models: model)
            self.heightArr.append(contentsOf: newHeights)
            for msg in model {
                dataArr.append(msg)
                let indexPath = IndexPath(row: dataArr.count - 1, section: 0)
                //                self.tableView.reloadData()
                //                self.tableView.layoutIfNeeded()
                //                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                self.insertRows([indexPath], atBottom: true)
            }
        } else {
            var oldIndexPath = IndexPath(row: model.count, section: 0)
            for msg in model {
                dataArr.insert(msg, at: 0)
                let newHeight = ChatMsgDataHelper.shared.getCellHeights(models: [msg]).first
                heightArr.insert(newHeight ?? 0, at: 0)
            }
            self.weakTableView?.reloadData()
            self.weakTableView?.layoutIfNeeded()
            if model.count > 0 {
                oldIndexPath.row = model.count - 1
                self.weakTableView?.scrollToRow(at: oldIndexPath, at: .top, animated: false)
            }
        }
    }
    
    fileprivate func insertRows(_ rows: [IndexPath], atBottom: Bool = true) {
        UIView.setAnimationsEnabled(false)
        self.weakTableView?.beginUpdates()
        self.weakTableView?.insertRows(at: rows, with: .none)
        self.weakTableView?.endUpdates()
        if atBottom {
            self.scrollToBottom()
        }
        UIView.setAnimationsEnabled(true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let model = dataArr[indexPath.row];
        if model.modelType == .text {
            let cell: ChatTextViewCell = tableView.dequeueReusableCell(withIdentifier: ChatTextViewCellID, for: indexPath) as! ChatTextViewCell
            cell.model = dataArr[indexPath.row];
            cell.row = indexPath.row
            cell.delegate = self.delegate
            return cell
        } else if model.modelType == .image {
            let cell: ChatImageCell = tableView.dequeueReusableCell(withIdentifier: ChatImageCellID, for: indexPath) as! ChatImageCell
            cell.model = dataArr[indexPath.row];
            return cell
        } else if model.modelType == .file {
            let cell: ChatFileCell = tableView.dequeueReusableCell(withIdentifier: ChatFileCellID, for: indexPath) as! ChatFileCell
            cell.model = dataArr[indexPath.row]
            return cell
        } else {
            let cell: ChatTimeCell = tableView.dequeueReusableCell(withIdentifier: ChatTimeCellID, for: indexPath) as! ChatTimeCell
            cell.model = dataArr[indexPath.row];
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightArr[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.delegate?.hideKeyboardView()
    }
}
