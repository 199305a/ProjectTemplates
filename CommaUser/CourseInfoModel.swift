//
//  CourseInfoModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class CourseInfoModel: BaseModel, CourseCustomDate, CourseBooking {
    
    var schedule_id: String?
    var is_fee: Int = InvalidInteger
    var isFee: Bool {
        return is_fee == 1
    }
    var price: String?
    var course_name: String?
    var trainer: String?
    var date: String?
    var week: String?
    var start_time: String?
    var end_time: String?
    var course_intensity: Int = 0
    var desc: String?
    var people_num: String?
    var booked_num: String?
    var gym_name: String?
    var room_name: String?
    var address: String?
    var images: [String] = []
    var gym_images: [String] = []
    var is_order: Int = InvalidInteger
    var orderStatus: GourpCourseOrderStatus {
        return GourpCourseOrderStatus(rawValue: is_order) ?? .unknown
    }
    var coupon_num: String?
    var gym_id: String?
    var course_desc: String?
    
}



class GymImageModel: BaseModel {
    var object_id: String?
    var title: String?
    var url: String?
    
}

enum GourpCourseOrderStatus: Int {
    case unknown, allowToOrder, bookedAll, closed, ongoing, over, alreadyOrdered
    
    var text: String? {
        var str: String?
        switch self {
        case .unknown:
            str = "--"
        case .allowToOrder:
            str = "我要上课"
        case .bookedAll:
            str = "已约满"
        case .closed:
            str = "已关闭预约"
        case .ongoing:
            str = "进行中"
        case .over:
            str = "已结束"
        case .alreadyOrdered:
            str = "已预约"
        }
        return str
    }
}



