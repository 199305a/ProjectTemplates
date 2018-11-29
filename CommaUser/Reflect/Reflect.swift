//
//  Reflect.swift
//  Reflect
//
//  Created by 冯成林 on 15/8/19.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation

@objcMembers
class Reflect: NSObject, NSCoding{
    
    lazy var mirror: Mirror = {Mirror(reflecting: self)}()
    
    required override init(){}
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        self.init()
        
        let ignorePropertiesForCoding = self.ignoreCodingPropertiesForCoding()
        
        self.properties { [unowned self] (name, type, value) in
            
            assert(type.check(), "[Charlin Feng]: Property '\(name)' type can not be a '\(type.realType.rawValue)' Type,Please use 'NSNumber' instead!")
            
            let hasValue = ignorePropertiesForCoding != nil
            
            dLog("aDecoder:\(name),\(aDecoder.decodeObject(forKey: name) ?? "")")
            
            
            if hasValue {
                
                let ignore = (ignorePropertiesForCoding!).contains(name)
                
                if !ignore {
                    
                    self.setValue(aDecoder.decodeObject(forKey: name), forKeyPath: name)
                }
                
            }else{
                
                self.setValue(aDecoder.decodeObject(forKey: name), forKeyPath: name)
            }
        }
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        let ignorePropertiesForCoding = self.ignoreCodingPropertiesForCoding()
        
        self.properties { (name, type, value) -> Void in
            
            let hasValue = ignorePropertiesForCoding != nil
            
            if hasValue {
                
                let ignore = (ignorePropertiesForCoding!).contains(name)
                
                if !ignore {
                    
                    aCoder.encode(value as AnyObject, forKey: name)
                }
            }else{
                
                if type.isArray {
                    
                    if type.isReflect {
                        
                        aCoder.encode(value as? NSArray, forKey: name)
                        
                    }else {
                        aCoder.encode(value as AnyObject, forKey: name)
                    }
                    
                }else {
                    var v = "\(value)".replacingOccurrencesOfString("Optional(", withString: "").replacingOccurrencesOfString(")", withString: "")
                    v = v.replacingOccurrencesOfString("\"", withString: "")
                    if v != "nil" {
                        aCoder.encode(v, forKey: name)
                    }
                }
            }
        }
    }
    
    func parseOver(){}
}



