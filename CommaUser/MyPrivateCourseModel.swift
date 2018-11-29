//
//  MyPrivateCourseModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class MyPrivateCourseModel: BaseModel {
    var order_id: String?
    var course_state: Int = InvalidInteger
    var trainer_name: String?
    var course_name: String?
    var gym_name: String?
    var start_time: String?
    var end_time: String?
    var times: String?
    var complete_times: String?
    var miss_times: String?
    var progress: [MyPrivateCourseProgressModel] = []
    
    var courseDesc: String {
        return Text.Course + "：" + course_name.nonOptional
    }
    var timeDesc: String {
        return Text.ExpiryDate + "：" + start_time.nonOptional + " ~ " + end_time.nonOptional
    }
    var locDesc: String {
        return "场馆" + "：" + gym_name.nonOptional
    }
    var courseStatus: PrivateCourseStatus? {
        return PrivateCourseStatus.init(rawValue: course_state)
    }
    var progressNumDesc: String {
        return complete_times.nonOptional + "/" + times.nonOptional
    }
}

class MyPrivateCourseProgressModel: BaseModel {
    var course_time: String?
    var progress_type: Int = InvalidInteger
    var order_id: String?
    var status: Status? {
        return Status.init(rawValue: progress_type)
    }
    
    enum Status: Int {
        case done = 1
        case absence
        case cancel
        
        var description: String {
            switch self {
            case .done:
                return Text.Done
            case .absence:
                return "失约"
            case .cancel:
                return "销课"
            }
        }
    }
}

enum PrivateCourseStatus: Int {
    case notStart = 1
    case pause
    case ongoing
    case done
    case expire
    
    var description: String {
        switch self {
        case .notStart:
            return Text.NotStart
        case .pause:
            return "已冻结"
        case .ongoing:
            return "未完成"
        case .done:
            return "已完成"
        case .expire:
            return "已过期"
        }
    }
}

class PrivateCourseListModel: BaseModel {
    var list: [MyPrivateCourseModel]!
    var has_more: Int = InvalidInteger
    var hasMore: Bool! {
        return has_more == 1
    }
}
