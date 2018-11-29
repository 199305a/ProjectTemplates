//
//  NSObject+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 16/12/6.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit

extension NSObject {
    
    /**
     获取对象对于的属性值，无对于的属性则返回NIL
     
     - parameter property: 要获取值的属性
     
     - returns: 属性的值
     */
    func getValueOfProperty(_ property:String)->AnyObject?{
        let allPropertys = self.getAllPropertys()
        if(allPropertys.contains(property)){
            return self.value(forKey: property) as AnyObject?
            
        }else{
            return nil
        }
    }
    
    /**
     设置对象属性的值
     
     - parameter property: 属性
     - parameter value:    值
     
     - returns: 是否设置成功
     */
    func setValueOfProperty(_ property:String,value:AnyObject)->Bool{
        let allPropertys = self.getAllPropertys()
        if(allPropertys.contains(property)){
            self.setValue(value, forKey: property)
            return true
            
        }else{
            return false
        }
    }
    
    /**
     获取对象的所有属性名称
     
     - returns: 属性名称数组
     */
    func getAllPropertys()->[String]{
        
        var result = [String]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyPropertyList(object_getClass(self), count)
        let countInt = Int(count[0])
        
        for i in 0 ..< countInt {
            guard let temp = buff?[i] else { continue }
            let pro = property_getName(temp)
            let proper = String.init(validatingUTF8: pro)
            result.append(proper!)
        }
        
        return result
    }
    
}

extension NSObject {
    
    var jsonString: String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return String.init(data: jsonData, encoding: String.Encoding.utf8)
        }
        return nil
    }
}

extension NSObject {
    
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


extension IndexPath {
    var tuple: (Int, Int) {
        return Tuple.init(indexPath: self)
    }
}

