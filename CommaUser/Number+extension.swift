//
//  Number+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

extension Int {
    
    var boolValue: Bool {
        
        if self == 0 {
            return false
        }
        return true
    }
    
    var color: UIColor {
        return UIColor.hexColor(self)
    }
}


extension Int {
    var toCGFloat: CGFloat {
        return CGFloat.init(self)
    }
}

extension Int {
    var toHMS: String? {
        
        let seconds = self
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
        let seconds = self
        //format of minute
        let str_minute = String.init(format: "%02ld", (seconds%3600)/60)
        //format of second
        let str_second = String.init(format: "%02ld", seconds%60)
        //format of time
        let format_time = String.init(format: "%@:%@",str_minute,str_second)
        
        return format_time
    }
}

extension Double {
    var toHMS: String? {
        return Int(self).toHMS
    }
    
    var toMS: String? {
        return Int(self).toMS
    }
}
