//
//  MyCourseModel.swift
//  CommaUser
//
//  Created by user on 2018/10/29.
//  Copyright © 2018 LikingFit. All rights reserved.
//

import UIKit

class MyCourseModel: BaseModel {
    
    var order_id: String?
    var user_id: String?
    var course_id: String?
    var course_state: Int = InvalidInteger
    var course_name: String?
    var gym_name: String?
    var room_name: String?
    var start_time: String?
    var end_time: String?
    var schedule_type: String?
    var times: String?
    var complete_times: String?
    var miss_times: String?
    var image: String?
    
    var courseStatus: TeamCourseStatus? {
        return TeamCourseStatus.init(rawValue: course_state)
    }
    
}


class MyCourseListModel: BaseModel {
    var list: [MyCourseModel] = []
    var has_more: Int = InvalidInteger
    var hasMore: Bool! {
        return  has_more == 1
    }
    
}
