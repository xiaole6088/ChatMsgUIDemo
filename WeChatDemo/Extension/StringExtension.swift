//
//  StringExtension.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/13.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import Foundation

extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    /// NSRange转化为range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    static func fileSize(fileLength: Int64) -> String {
        let fileLength: Double = Double(fileLength)
        if fileLength < 1024.0 {
            return String(format: "%.2fB", fileLength * 1.0)
        } else if (fileLength >= 1024.0 && fileLength < (1024.0*1024.0)){
            return String(format: "%.2fKB", fileLength/1024.0)
        } else if (fileLength >= (1024.0*1024.0) && fileLength < (1024.0*1024.0*1024.0)) {
           return String(format: "%.2fMB", fileLength/(1024.0*1024.0))
        }else{
           return String(format: "%.2fGB", fileLength/(1024.0*1024.0*1024.0))
        }
    }
}
