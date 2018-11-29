//
//  EventTracking.swift
//  CommaUser
//
//  Created by Marco Sun on 16/8/10.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit

class EventTracking: NSObject {
    
    class func event(_ eventId: String) {
        MobClick.event(eventId, label: LocationManager.currentLocation?.city_name)
    }
    
    class func event(_ eventId: String, attributes: [AnyHashable: Any]) {
        MobClick.event(eventId, attributes: attributes)
    }
    
    class func event(_ eventId: String, label: String) {
        MobClick.event(eventId, label: label)
    }
}
