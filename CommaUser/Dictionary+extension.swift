//
//  Dictionary+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 16/5/20.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit

// 对付 optional nil的大杀器
extension Dictionary {
    subscript (safe key: Key) -> Value? {
        get {
            return self[key]
        }
        set {
            if String(describing: newValue) != "Optional(nil)" && String(describing: newValue) != "Optional(\"nil\")" {
                self[key] = newValue
            } else {
                self[key] = nil
            }
        }
    }
}

extension Dictionary where Key: ExpressibleByStringLiteral, Value: AnyObject {
    var results: AnyObject? {
        return self["results"]
    }

    var next: AnyObject? {
        return self["next"]
    }
    
}

extension Dictionary {
    var debugString: String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return self.description
        }
        return String.init(data: data, encoding: .utf8) ?? self.description
    }
}


// NetWorker
extension Dictionary where Key: StringProtocol, Value: AnyObject {
    var parseList: [AnyObject] {
        return (self["list"] as? [AnyObject]) ?? []
    }
    
    func parseList<T: Reflect>(_ classType: T.Type) -> [T] {
        return (classType.parses(array: parseList) as? [T]) ?? []
    }
}

extension Array where Element: Reflect {
    static func parse(_ arr: [Any]) -> [Element] {
        return (Element.parses(array: arr) as? [Element]) ?? []
    }
}


extension Dictionary {
    
    var jsonString: String? {
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: []) {
            return String.init(data: jsonData, encoding: String.Encoding.utf8)
        }
        return nil
    }
}
