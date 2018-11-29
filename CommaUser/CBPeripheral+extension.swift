//
//  CBPeripheral+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 16/12/27.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import CoreBluetooth

extension CBPeripheral {
    
    fileprivate struct AssociatedKeys {
        static var likingFitPeripheral = "_likingFitPeripheral"
    }
    
    
    var likingFitModel: LikingFitPeripheral? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.likingFitPeripheral) as? LikingFitPeripheral
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.likingFitPeripheral, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var isLikingFit: Bool { return likingFitModel != nil }
    var isBracelet: Bool { return likingFitModel?.type == .bracelet }
    
}

class LikingFitPeripheral: NSObject {
    
    var type: LikingFitPeripheralType!
    
    init(type: LikingFitPeripheralType = .unknown) {
        self.type = type
    }
    
}

enum LikingFitPeripheralType: Int {
    case unknown = -1
    case bracelet = 1
}
