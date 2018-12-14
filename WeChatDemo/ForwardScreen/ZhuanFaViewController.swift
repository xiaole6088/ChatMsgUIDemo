//
//  ZhuanFaViewController.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/13.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

class ZhuanFaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var zhuanfaMsg: ChatMsgModel?
    
    @IBOutlet weak var morePeopleWidth: NSLayoutConstraint!
    @IBOutlet weak var moreSearchTextFiedl: UITextField!
    @IBOutlet weak var moreViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var moreCollectionView: UICollectionView!
    
    var people: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTableView.delegate = self
        contactTableView.dataSource = self
        // Do any additional setup after loading the view.
        self.setDuoXuan(duoxuan: false)
        moreCollectionView.delegate = self
        moreCollectionView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle(rawValue: UITableViewCell.EditingStyle.delete.rawValue | UITableViewCell.EditingStyle.insert.rawValue) ?? .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        cell.textLabel?.text = "好友"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            people.append("1")
            resetMoreView()
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "发送给:\n好友", message: zhuanfaMsg?.text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "确定", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if people.count > 0 {
                people.removeLast()
            }
            resetMoreView()
        }
    }
    
    @objc func duoxuanDoneAction() {
        let alert = UIAlertController(title: "发送给:\n多人", message: zhuanfaMsg?.text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "确定", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func duoxuanCancelAction() {
        self.setDuoXuan(duoxuan: false)
    }
    
    @objc func duoxuanAction() {
        self.setDuoXuan(duoxuan: true)
    }
    
    @objc func closeAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func resetMoreView() {
        self.morePeopleWidth.constant = getMoreUserWidth()
        self.view.layoutIfNeeded()
        self.moreCollectionView.reloadData()
    }
    
    func getMoreUserWidth() -> CGFloat {
        let count = people.count
        if count == 0 {
            return 0
        }
        var width: CGFloat = CGFloat(30*count)
        width += CGFloat((count - 1)*5)
        let maxWidth: CGFloat = self.view.frame.width - 30.0 - 60.0
        if width >= maxWidth {
            width = maxWidth
        }
        return width
    }
    
    func setDuoXuan(duoxuan: Bool) {
        if duoxuan {
            let cancel = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(duoxuanCancelAction))
            let done = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(duoxuanDoneAction))
            self.navigationItem.leftBarButtonItem = cancel
            self.navigationItem.rightBarButtonItem = done
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                self.moreViewTopMargin.constant = 0
                self.view.layoutIfNeeded()
            }
            self.contactTableView.setEditing(true, animated: true)
        } else {
            self.contactTableView.setEditing(false, animated: true)
            self.moreSearchTextFiedl.resignFirstResponder()
            let close = UIBarButtonItem(title: "关闭", style: .done, target: self, action: #selector(closeAction))
            let duoxuan = UIBarButtonItem(title: "多选", style: .done, target: self, action: #selector(duoxuanAction))
            self.navigationItem.leftBarButtonItem = close
            self.navigationItem.rightBarButtonItem = duoxuan
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                self.moreViewTopMargin.constant = -44
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension ZhuanFaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
}
