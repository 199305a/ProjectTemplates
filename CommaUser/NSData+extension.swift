//
//  NSData+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 17/1/20.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

extension NSMutableData {
    
    convenience init(bytes: [UInt8]) {
        self.init(data: Data.init(bytes: bytes))
    }
}


extension Data {
    var hexStr: String {
        return map { String(format: "%02.2hhx", $0) }.joined()
    }
}
