//
//  TrainerSubscribeInfoModel.swift
//  CommaUser
//
//  Created by macbook on 2018/11/12.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class TrainerSubscribeInfoModel: BaseModel {
    var gym:GymsModel?
    var people_num:String?
    var course_info:String?
}

class TrainerSubscribeCourseModel: BaseModel {
    var course_id:String?
    var remain_times:String?
    var end_time:String?
    var personal_id:String?
    var course_name:String?
    var duration:String?
}
