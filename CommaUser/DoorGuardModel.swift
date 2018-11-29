//
//  DoorGuardModel.swift
//  CommaUser
//
//  Created by yuanchao on 2018/5/11.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class DoorGuardModel: BaseModel {
    
    var name: String?
    var images: [ImageModel]?
    var bluetooth = [DoorGuardBluetoothModel]()
    var imgUrlStr: String? {
        return images?.first?.url
    }
    
}

class DoorGuardBluetoothModel: BaseModel {
    var mac: String?
    var action: String?
}
