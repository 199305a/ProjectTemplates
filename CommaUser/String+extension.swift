//
//  String+extensions.swift
//  CommaUser
//
//  Created by Marco Sun on 16/5/17.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import Foundation
import CoreImage

extension String {
    var length:Int {return count}
    
    var splitArr: [String] {
        if String.isEmptyString(self as AnyObject?) {
            return [String]()
        }
        
        return components(separatedBy: Text.Split)
    }
    
    //    func defaultsKey() -> String {
    ////        return "\(self)_\(AppUser.memberId)_\(AppVersion)"
    //    }
    
    func shortTagStr() -> String {
        let placeStr = "   "
        return placeStr + self + placeStr
    }
    
    func space1Str() -> String {
        let placeStr = " "
        return placeStr + self + placeStr
    }
    
    func tagStrWithCloseSymbol() -> String {
        let placeStr = "   "
        return placeStr + self + "  ×" + placeStr
    }
    
    static func isNotEmptyString(_ string: Any?) -> Bool {
        return !String.isEmptyString(string)
    }
    
    static func isEmptyString(_ string: Any?) -> Bool {
        if let temp = string {
            if temp is NSNull {
                return false
            }
            
            if !(temp is String) {
                return false
            }
            
            return (temp as! String).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
        }
        
        return true
    }
    
    func containsString(_ s:String) -> Bool
    {
        if(self.range(of: s) != nil)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func containsString(_ s:String, compareOption: NSString.CompareOptions) -> Bool
    {
        if((self.range(of: s, options: compareOption)) != nil)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func reverse() -> String
    {
        var reverseString : String = ""
        for c in self
        {
            reverseString = String(c) + reverseString
        }
        return reverseString
    }
    
    
    func subStringInRange(_ startIndex: Int, endIndex: Int) -> String? {
        guard startIndex < endIndex else { return nil }
        guard self.length > endIndex else { return nil }
        return String(self[self.index(self.startIndex, offsetBy: startIndex)...self.index(self.startIndex, offsetBy: endIndex)])
    }
    
    func subStringAtIndex(_ index: Int) -> String {
        guard index < count else {
            return ""
        }
        let p = self.index(self.startIndex, offsetBy: index)
        let l = self.index(self.startIndex, offsetBy: index + 1)
        return String(self[p..<l])
    }
    
    // MARK: --- 汉语转拼音 ---
    func pinyinValue() -> String {
        
        var tempPinyin = ""
        let str = NSMutableString(string: self) as CFMutableString
        guard CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false) else {
            return tempPinyin
        }
        guard CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) else {
            return tempPinyin
        }
        tempPinyin = str as String
        
        //城市多音字的处理
        guard let ch = first else {
            return ""
        }
        switch ch {
        case "长" where tempPinyin.contains("zhang"):
            tempPinyin = tempPinyin.replacingOccurrences(of: "zhang", with: "chang")
        case "沈" where tempPinyin.contains("chen"):
            tempPinyin = tempPinyin.replacingOccurrences(of: "chen", with: "shen")
        case "厦" where tempPinyin.contains("sha"):
            tempPinyin = tempPinyin.replacingOccurrences(of: "sha", with: "xia")
        case "重" where tempPinyin.contains("zhong"):
            tempPinyin = tempPinyin.replacingOccurrences(of: "zhong", with: "chong")
        default:
            break
        }
        return tempPinyin
        
    }
    
    // tag数组回string
    static func tagsToString(_ tags: [String]?) -> String {
        
        guard Array.isSafe(tags) else {
            return " "
        }
        var str = String()
        
        tags!.forEach { string in
            str.append("#\(string) ")
        }
        return str
    }
    
    
    /**
     数值在区间内
     */
    func inRange(_ min: Int, max: Int) -> Bool {
        
        guard GlobalAction.isNumber(self) else { return false }
        
        if let tmp = intValue, tmp < max && tmp > min { return true }
        
        if let tmp = lf_doubleValue, tmp < Double(max) && tmp > Double(min) { return true }
        
        return false
        
    }
    
    /**
     如果有数值并且超过或者小于边界值的时候获得边界值，其他时候获得当前值
     */
    func obtainMarginalValueWhenOutOfRange(_ min: Int, max: Int) -> Int? {
        
        guard min < max else { return nil }
        
        guard GlobalAction.isNumber(self) else { return nil }
        
        if let tmp = intValue, tmp < max && tmp > min { return tmp }
        
        if let tmp = lf_doubleValue, tmp < Double(max) && tmp > Double(min) { return Int(tmp) }
        
        if let tmp = intValue, tmp < min { return min }
        
        if let tmp = intValue, tmp > max { return max }
        
        if let tmp = lf_doubleValue, tmp > Double(max)  { return max }
        
        if let tmp = lf_doubleValue, tmp < Double(min) { return min }
        
        return nil
    }
    
    func obtainMarginaStringWhenOutOfRange(_ min: Int, max: Int) -> String? {
        
        guard min < max else { return nil }
        
        guard GlobalAction.isNumber(self) else { return nil }
        
        if let tmp = intValue, tmp < max && tmp > min { return "\(tmp)" }
        
        if let tmp = lf_doubleValue, tmp < Double(max) && tmp > Double(min) { return "\(tmp)" }
        
        if let tmp = intValue, tmp < min { return String(min) }
        
        if let tmp = intValue, tmp > max { return String(max) }
        
        if let tmp = lf_doubleValue, tmp > Double(max)  { return String(max) }
        
        if let tmp = lf_doubleValue, tmp < Double(min) { return String(min) }
        
        return nil
    }
    
}


extension String {
    
    var hasIntValue: Bool {
        if let _ = Int.init(self) { return true }
        return false
    }
    
    var hasDoubleValue: Bool {
        if let _ = Double.init(self) { return true }
        return false
    }
    
    var intValue: Int? {
        
        return Int.init(self)
    }
    
    var lf_doubleValue: Double? {
        
        return Double.init(self)
    }
    
}

extension Foundation.URL {
    
    static func stringURL(_ string: String?) -> Foundation.URL {
        
        guard let string = string else {
            return URL.init(string: "http")!
        }
        
        if let url = URL.init(string: string) {
            return url
        }
        return URL.init(string: "http")!
    }
}

extension NSAttributedString {
    static func htmlString(_ string: String?) -> NSAttributedString? {
        guard let _ = string else { return nil }
        guard let data = string!.data(using: String.Encoding.unicode) else { return nil }
        guard let str = try? NSAttributedString.init(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else { return nil }
        return str
    }
    
}

extension String {
    
    
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).deletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).deletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(_ path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(_ ext: String) -> String? {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathExtension(ext)
    }
    
}

extension String {
    
    func contains(_ str: String) -> Bool {
        return (self as NSString).contains(str)
    }
    
}

// MARK: - URL
extension String {
    
    var toURL: URL? {
        return URL.init(string: self)
    }
    
}

extension String {
    var boolValue: Bool {
        if self == "false" || self == "0" {
            return false
        }
        return true
    }
    
    var image: UIImage? {
        return UIImage.init(named: self)
    }
}

extension String {
    var toHMS: String? {
        guard let seconds = self.intValue else {
            return nil
        }
        //format of hour
        let str_hour = String.init(format: "%02ld", seconds/3600)
        //format of minute
        let str_minute = String.init(format: "%02ld", (seconds%3600)/60)
        //format of second
        let str_second = String.init(format: "%02ld", seconds%60)
        //format of time
        let format_time = String.init(format: "%@:%@:%@", str_hour,str_minute,str_second)
        
        return format_time
    }
    
    var toMS: String? {
        guard let seconds = self.intValue else {
            return nil
        }
        //format of minute
        let str_minute = String.init(format: "%02ld", (seconds%3600)/60)
        //format of second
        let str_second = String.init(format: "%02ld", seconds%60)
        //format of time
        let format_time = String.init(format: "%@:%@",str_minute,str_second)
        
        return format_time
    }
}

extension String {
    
    //MARK: - 将 1000000 显示为 1,000,000
    var commasString: String {
        let num = self
        
        func separateWithCommas(_ str: String, orderForward:Bool) -> String {
            var tempStr = str
            let len = tempStr.count
            let maxSignNum = (len - 1) / 3
            
            for signNum in 0 ..< maxSignNum {
                let i = 3 * (signNum + 1) + signNum
                if orderForward {
                    tempStr.insert(",", at: tempStr.index(tempStr.startIndex, offsetBy: i))
                } else {
                    tempStr.insert(",", at: tempStr.index(tempStr.endIndex, offsetBy: -i))
                }
            }
            return tempStr
        }
        
        let numStr = "\(num)"
        let numStrArr = numStr.components(separatedBy: ".")
        if numStrArr.count > 2 {
            return "\(num)"
        }
        var tempStr = ""
        for (i,str) in  numStrArr.enumerated() {
            tempStr += separateWithCommas(str, orderForward: i == 1)
            if i < numStrArr.count - 1 {
                tempStr += "."
            }
        }
        return tempStr
    }
}

extension String {
    //MARK: 生成二维码
    func generateQR(width: CGFloat) -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = self.data(using: String.Encoding.utf8)
        filter?.setValue(data, forKey: "inputMessage")
        
        let outImg = filter?.outputImage
        
        return outImg?.getQRImage(withSize: width)
    }
    
}
