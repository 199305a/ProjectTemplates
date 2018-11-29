//
//  GymInfoModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class GymInfoModel: BaseModel {
    
    var gym_id: String?
    var gym_name: String?
    var address: String?
    var tel: String?
    var open_time: String?
    var bis_status: String?
    var has_wifi: Int = InvalidInteger
    var has_shower: Int = InvalidInteger
    var has_room: Int = InvalidInteger
    var is_all_day: Int = InvalidInteger
    var images: [String] = []
    var longitude: String?
    var latitude: String?
}

class GymTagModel: BaseModel {
    var name: String?
    var url: String?
    
}

class GymInfoImageModel: BaseModel {
    var title: String?
    var url: String?
}
