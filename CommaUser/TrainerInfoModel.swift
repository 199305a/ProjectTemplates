//
//  TrainerInfoModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class TrainerInfoModel: BaseModel, CoursePriceProtocol {
    var subscrible:Int = InvalidInteger
    var trainer_id: String?
    var trainer_name: String?
    var gender: Int = InvalidInteger
    var height: String?
    var weight: String?
    var desc: String?
    var images: [String] = []
    var tags: [TagModel] = []
    var max_price: String?
    var min_price: String?
    var courses: [String] = []
    var gyms: [GymsModel] = []
    var trainerGender: Gender {
        return Gender(rawValue: gender) ?? .unknown
    }
    var course_price: String?
}

class GymsModel: BaseModel {
    var gym_name: String?
    var gym_id: String?
    var distance: String?
}

class CourseModel: BaseModel {
    var course_id: String?
    var name: String?
}

class TrainerTimeModel: BaseModel {
    var week:String?
    var day:String?
    var year:String?
    var month:String?
    var contents:[TrainerTimeSateModel]?
    
//    var weekStr:String? {
//        return      CalendarManager.tranformWeekToChineseCharacter(week:self.week , prefix: "周")
//    }
    
}

class TrainerTimeSateModel: BaseModel {
    var state:Int = InvalidInteger
    var duration:String?
    var date:String?
    
    
    var stateStr:String? {
        if state == 0 {
            return "预约"
        }
        if state == 1 {
            return "已预约"
        }
        return "--"
    }
}
