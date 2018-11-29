//
//  Foundation+Extensions.swift
//  CommaUser
//
//  This file is used to put extensions of basic types
//
//  Created by Marco Sun on 16/4/13.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit

//扩展Double
extension Double {
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
    
    func roundToDecimalDigits(_ decimals:Int) -> Double
    {
        let a : Double = self
        let format : NumberFormatter = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.decimal
        format.roundingMode = NumberFormatter.RoundingMode.halfUp
        format.maximumFractionDigits = 2
        let string: NSString = format.string(from: NSNumber(value: a as Double))! as NSString
        dLog("\(string.doubleValue)")
        return string.doubleValue
    }
}

extension Int{
    var isEven:Bool     {return (self % 2 == 0)}
    var isOdd:Bool      {return (self % 2 != 0)}
    var isPositive:Bool {return (self >= 0)}
    var isNegative:Bool {return (self < 0)}
    var toDouble:Double {return Double(self)}
    var toFloat:Float   {return Float(self)}
    
    var digits:Int {//this only works in bound of LONG_MAX 2147483647, the maximum value of int
        if(self == 0)
        {
            return 1
        }
        else if(Int(fabs(Double(self))) <= LONG_MAX)
        {
            return Int(log10(fabs(Double(self)))) + 1
        }
        else
        {
            return -1; //out of bound
        }
    }
}

extension CGRect {
    var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            origin.x = newValue
        }
    }
    var y: CGFloat {
        get {
            return self.origin.y
        }
        set {
            origin.y = newValue
        }
    }
    var width: CGFloat {
        get {
            return self.size.width
        }
        set {
            size.width = newValue
        }
    }
    var height: CGFloat {
        get {
            return self.size.height
        }
        set {
            size.height = newValue
        }
    }
}

extension CGPoint {
    func equalTo(_ point: CGPoint) -> Bool {
        return self.equalTo(point)
    }
}

extension NSNull {
    func length() -> Int { return 0 }
    
    func integerValue() -> Int { return 0 }
    
    func floatValue() -> Float { return 0 };
    
    func componentsSeparatedByString(_ separator: String) -> [AnyObject] { return [AnyObject]() }
    
    func objectForKey(_ key: AnyObject) -> AnyObject? { return nil }
    
    func boolValue() -> Bool { return false }
}

extension Int {
    var layout: CGFloat {
        let number = self as NSNumber
        return  Layout.layoutScaleWidth(CGFloat.init(truncating: number))
    }
    var addSafeAreaBottom: CGFloat {
        return CGFloat(self) + Layout.safeAreaInsetsBottom
    }
    var layoutIf5S: CGFloat {
        guard Layout.is_window_4_inch else {
            return CGFloat(self)
        }
        let number = self as NSNumber
        return  Layout.layoutScaleWidth(CGFloat.init(truncating: number))
    }
}

extension Double {
    var layout: CGFloat {
        let number = self as NSNumber
        return  Layout.layoutScaleWidth(CGFloat.init(truncating: number))
    }
    var addSafeAreaBottom: CGFloat {
        return CGFloat(self) + Layout.safeAreaInsetsBottom
    }
    var layoutIf5S: CGFloat {
        guard Layout.is_window_4_inch else {
            return CGFloat(self)
        }
        let number = self as NSNumber
        return  Layout.layoutScaleWidth(CGFloat.init(truncating: number))
    }
    
}

extension CGFloat {
    var layout: CGFloat {
        return Layout.layoutScaleWidth(self)
    }
    var addSafeAreaBottom: CGFloat {
        return self + Layout.safeAreaInsetsBottom
    }
    var layoutIf5S: CGFloat {
        guard Layout.is_window_4_inch else {
            return self
        }
        return  Layout.layoutScaleWidth(self)
    }
}

extension Optional where Wrapped: StringProtocol {
    var nonOptional: Wrapped {
        return self ?? ""
    }
}



