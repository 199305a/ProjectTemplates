//
//  MyScheduleModel.swift
//  CommaUser
//
//  Created by user on 2018/10/29.
//  Copyright © 2018 LikingFit. All rights reserved.
//

import UIKit

class MyScheduleModel: BaseModel {
    var schedule_id = ""
    var course_id = ""
    var course_name = ""
    var start_time = ""
    var end_time = ""
    var course_date = ""
    var is_evaluate = ""
    var course_status = ""
    var course_type = ""
    var image = ""
    var gym_name = ""
    var address = ""
    var week = ""
    var date = ""
    var trainer_name = ""
    
}

class MyScheduleListModel: BaseModel {
    var list: [MyScheduleModel] = []
    var has_more: Int = InvalidInteger
    var hasMore: Bool! {
        return  has_more == 1
    }
    
}
