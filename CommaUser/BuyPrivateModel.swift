//
//  BuyPrivateModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class BuyPrivateModel: BaseModel {
    var courses: [BuyPrivateCourseModel] = []
    var gym: PlacesModel?
    var end_time: String?
    var people_num: String?
    var trainer_name: String?
}

class BuyPrivateCourseModel: BaseModel {
    var remain_times:String?
    var end_time:String?
    var personal_id:String?
    var course_id:String?
    var course_name: String?
    var duration: String?
    var price: String?
    var course_personal_id: String?
    var coupon_num: String?
    var min_times: Int = InvalidInteger {
        didSet {
            if min_times >= 0 { return }
            min_times = 0
        }
    }
    var max_times: Int = InvalidInteger {
        didSet {
            if max_times >= 0 { return }
            max_times = 0
        }
    }
    
    var current_times: Int = InvalidInteger {
        didSet {
            if current_times >= 0 { return }
            current_times = 0
        }
    }
    var current_priceTime: TrainerCourseNewPriceTimeModel = TrainerCourseNewPriceTimeModel()
    
}

class PlacesModel: BaseModel {
    var gym_name: String?
    var address: String?
}



class TrainerCourseNewPriceTimeModel: BaseModel {
    var end_time: String?
    var price: String?
    
    var isNew: Bool {
        if end_time == nil && price == nil {
            return true
        }
        return false
    }
    
}
