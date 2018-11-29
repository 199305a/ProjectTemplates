//
//  MyTeamCourseDetailModel.swift
//  CommaUser
//
//  Created by user on 2018/10/29.
//  Copyright © 2018 LikingFit. All rights reserved.
//

import UIKit

class MyTeamCourseDetailModel: BaseModel {
    var schedule_id: Int = -1
    var course_name: String = ""
    var date: String = ""
    var week: String = ""
    var start_time: String = ""
    var end_time: String = ""
    var course_intensity: Int = -1
    var course_status: Int = -1
    var is_sign: Int = 0
    var resveration_id: Int = -1
    var times: Int = 0
    var complete_times: Int = 0
    var gym_name: String = ""
    var address: String = ""
    var cancel_reason: String = ""
    var is_evaluate: String = ""
    
    var courseStatus: MyCourseStatusType? {
        return MyCourseStatusType(rawValue: course_status)
    }
    
}

