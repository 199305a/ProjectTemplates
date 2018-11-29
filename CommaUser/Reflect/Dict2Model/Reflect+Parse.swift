//
//  Reflect+Parse.swift
//  Reflect
//
//  Created by 成林 on 15/8/23.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation


extension Reflect{
    
    class func parsePlist(_ name: String) -> Self?{
        
        let path = Bundle.main.path(forResource: name+".plist", ofType: nil)
        
        if path == nil {return nil}
        
        let dict = NSDictionary(contentsOfFile: path!)
        
        if dict == nil {return nil}
        
        return parse(dictionary: dict!)
    }
    
    class func parses(array: [Any]) -> [Reflect]{
        return parses(arr: array as NSArray)
    }
    
    class func parses(arr: NSArray) -> [Reflect]{
        
        var models: [Reflect] = []
        
        for (_ , dict) in arr.enumerated(){
            
            let model = self.parse(dictionary: dict as! NSDictionary)
            
            models.append(model)
        }
        
        return models
    }
    
    class func parse(dict: [String: Any]) -> Self {
        return parse(dictionary: dict as NSDictionary)
    }
    
    class func parse(dictionary: NSDictionary) -> Self{
        
        let dict = dictionary
        
        let model = self.init()
        
        let mappingDict = model.mappingDict()
        
        let ignoreProperties = model.ignorePropertiesForParse()
        
        model.properties { [unowned model] (name, type, value) -> Void in
            
            let dataDictHasKey = dict[name] != nil
            let mappdictDictHasKey = mappingDict?[name] != nil
            let needIgnore = ignoreProperties == nil ? false : (ignoreProperties!).contains(name)
            
            if (dataDictHasKey || mappdictDictHasKey) && !needIgnore {
                
                let key = mappdictDictHasKey ? mappingDict![name]! : name
                
                if !type.isArray {
                    
                    if !type.isReflect {
                        
                        if type.typeClass == Bool.self { //bool
                            
                            model.setValue((dict[key] as AnyObject).boolValue, forKeyPath: name)
                            
                        }else{
                            
                            var dictValue = dict[key]
                            
                            if let tmp = dictValue {
                                
                                if (tmp as AnyObject).isEqual(NSNull.init()) {
                                    
                                    if type.typeName == "Int" { // 如果后台回的Int类型数据为空 则手动置成无效数据
                                        
                                        dictValue = InvalidInteger
                                        
                                    } else if type.typeName == "String" {
                                        
                                        dictValue = ""
                                        
                                    } else {
                                        
                                        dictValue = nil
                                    }
                                }
                            }
                            
                            if dictValue is String  && type.typeName == "Int" {
                                
                                dictValue = Int.init(dictValue as! String)
                                
                                if dictValue == nil {
                                    
                                    dictValue = InvalidInteger
                                    
                                }
                                
                            } else if dictValue is NSNumber && type.typeName == "String" {
                                if dictValue is Int {
                                    dictValue = String(describing: dictValue!)
                                } else if dictValue is Double {
                                    dictValue = String(Double.init(truncating: dictValue as! NSNumber))
                                } else {
                                    dictValue = String(describing: dictValue!)
                                }
                            }
                            
                            model.setValue(dictValue, forKeyPath: name)
                            
                        }
                        
                        
                        
                    }else{
                        
                        //这里是模型
                        //首选判断字典中是否有值
                        var dictValue = dict[key]
                        
                        if let tmp = dictValue {
                            
                            if (tmp as AnyObject).isEqual(NSNull.init()) {
                                
                                if type.typeName == "Int" { // 如果后台回的Int类型数据为空 则手动置成无效数据
                                    
                                    dictValue = InvalidInteger
                                    
                                } else if type.typeName == "String" {
                                    
                                    dictValue = ""
                                    
                                } else {
                                    
                                    dictValue = nil
                                }
                            }
                        }
                        
                        if dictValue is String  && type.typeName == "Int" {
                            
                            dictValue = Int.init(dictValue as! String)
                            
                            if dictValue == nil {
                                
                                dictValue = InvalidInteger
                                
                            }
                            
                        } else if dictValue is NSNumber && type.typeName == "String" {
                            if dictValue is Int {
                                dictValue = String(describing: dictValue!)
                            } else if dictValue is Double {
                                dictValue = String(Double.init(truncating: dictValue as! NSNumber))
                            } else {
                                dictValue = String(describing: dictValue!)
                            }
                        }
                        
                        if dictValue != nil { //字典中有模型
                            
                            let modelValue = model.value(forKeyPath: key)
                            
                            if modelValue != nil { //子模型已经初始化
                                
                                model.setValue((type.typeClass as! Reflect.Type).parse(dictionary: dict[key] as! NSDictionary), forKeyPath: name)
                                
                            }else{ //子模型没有初始化
                                
                                //先主动初始化
                                let cls = ClassFromString(type.typeName)
                                model.setValue((cls as! Reflect.Type).parse(dictionary: (dict[key] as? NSDictionary) ?? NSDictionary()), forKeyPath: name)
                            }
                        }
                        
                        
                        
                    }
                    
                }else{
                    
                    if let res = type.isAggregate(){
                        
                        var arrAggregate: [Any]
                        
                        if res is Int.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: ReflectType.BasicType.Int, ins: 0)
                        }else if res is Float.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: ReflectType.BasicType.Float, ins: 0.0)
                        }else if res is Double.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: ReflectType.BasicType.Double, ins: 0.0)
                        }else if res is String.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: ReflectType.BasicType.String, ins: "")
                        }else if res is NSNumber.Type {
                            arrAggregate = parseAggregateArray(dict[key] as! NSArray, basicType: ReflectType.BasicType.NSNumber, ins: NSNumber())
                        }else{
                            arrAggregate = dict[key] as! [AnyObject]
                        }
                        
                        model.setValue(arrAggregate, forKeyPath: name)
                        
                    }else{
                        
                        let elementModelType =  (ReflectType.makeClass(type) as! Reflect.Type)
                        
                        let dictKeyArr = dict[key] as! NSArray
                        
                        var arrM: [Reflect] = []
                        
                        for (_, value) in dictKeyArr.enumerated() {
                            
                            let elementModel = elementModelType.parse(dictionary: (value as? NSDictionary) ?? NSDictionary())
                            
                            arrM.append(elementModel)
                        }
                        
                        model.setValue(arrM, forKeyPath: name)
                    }
                }
                
            }
        }
        
        model.parseOver()
        
        return model
    }
    
    
    class func parseAggregateArray<T>(_ arrDict: NSArray,basicType: ReflectType.BasicType, ins: T) -> [T]{
        
        var intArrM: [T] = []
        
        if arrDict.count == 0 {return intArrM}
        
        for (_, value) in arrDict.enumerated() {
            
            var element: T = ins
            
            let v = "\(value)"
            
            
            
            if T.self is Int.Type {
                element = Int(Float(v)!) as! T
            }
            else if T.self is Float.Type {element = v.floatValue as! T}
            else if T.self is Double.Type {element = v.doubleValue as! T}
            else if T.self is NSNumber.Type {element = NSNumber(value: v.doubleValue! as Double) as! T}
            else{element = value as! T}
            
            
            intArrM.append(element)
        }
        
        return intArrM
    }
    
    
    func mappingDict() -> [String: String]? {return nil}
    
    func ignorePropertiesForParse() -> [String]? {return nil}
}

