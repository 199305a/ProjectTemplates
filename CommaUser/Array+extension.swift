//
//  Array+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 16/5/17.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import Foundation

// MARK: -- 安全 防数组越界 --
extension Array {
    
    static func isSafe(_ array: Array?) -> Bool {
        
        if array != nil && array!.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    
    //    func subArrayToIndex(index: Int) -> Array {
    //        return self[0..<min(index, count)]
    //    }
    
    subscript (safe index: Int) -> Element? {
        return (0 ..< count).contains(index) ? self[index] : nil
    }
    
    func safeObjectAtIndex(_ index: Int) -> Element? {
        return (0 ..< count).contains(index) ? self[index] : nil
    }
    
    mutating func insertToFirst(_ newElement: Element) {
        insert(newElement, at: 0)
    }
}

extension Sequence where Iterator.Element == String {
    var splitJoinedStr: String {
        return joined(separator: Text.Split)
    }
    
    var spacePointSpaceJoinedStr: String {
        return joined(separator: " \(Text.Point) ")
    }
}

extension Array where Element: AnyObject {
    
    var jsonString: String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: NSArray.init(array: self), options: .prettyPrinted) {
            return String.init(data: jsonData, encoding: String.Encoding.utf8)
        }
        return nil
    }
}
