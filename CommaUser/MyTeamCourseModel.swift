//
//  MyTeamCourseModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class MyTeamCourseModel: BaseModel, CourseCustomDate {
    
    var order_id: String?
    var course_state: Int = InvalidInteger
    var course_name: String?
    var gym_name: String?
    var room_name: String?
    var start_time: String?
    var end_time: String?
    var is_fee: String?
    var schedule_type: String?
    var price: String?
    var can_cancel: String?
    var date: String?
    var week: String?
    
    var timeDesc: String {
        return Text.Time + "：" + wholeDate.nonOptional
    }
    var locDesc: String {
        return Text.Store + "：" + gym_name.nonOptional + room_name.nonOptional
    }
    var courseStatus: TeamCourseStatus? {
        return TeamCourseStatus.init(rawValue: course_state)
    }
    var cancelEnable: Bool {
        return can_cancel == "1"
    }
    var isFree: Bool {
        return is_fee == "0"
    }
    
}

enum TeamCourseStatus: Int {
    case notStart = 1
    case doing
    case cancel
    case done
    
    var description: String {
        switch self {
        case .notStart:
            return Text.NotStart
        case .doing:
            return Text.OnGoing
        case .cancel:
            return Text.Canceled
        case .done:
            return Text.HasDone
        }
    }
}

class TeamCourseListModel: BaseModel {
    var list: [MyTeamCourseModel] = []
    var has_more: Int = InvalidInteger
    var hasMore: Bool! {
        return  has_more == 1
    }
    
}

