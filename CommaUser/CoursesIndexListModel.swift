//
//  CoursesIndexListModel.swift
//  CommaUser
//
//  Created by macbook on 2018/10/26.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class CoursesIndexListModel: BaseModel {
    var list:[CoursesListDetailModel] = []
}

class CoursesListDetailModel: BaseModel {
    var week :String?
    var day :String?
    var year :String?
    var month :String?

    var contents :[CoursesListContentModel] = []
}

class CoursesListContentModel: BaseModel {
     var course_name :String?
     var schedule_id :String?
    var images :String?
     var course_tag :[String] = []
     var course_time :String?
     var course_price :String?
    
//     var can_reservation :Int = InvalidInteger
    var course_reservation_status :Int = InvalidInteger
//    var full_people_status:Int = InvalidInteger

    var is_fee: Int = InvalidInteger
    var isFee: Bool {
        return is_fee == 1
    }
}

enum LittleGourpCourseOrderStatus: Int {
    
    case  allowToOrder,inOrder,cancleOrder,waitSure,deductClass,refundClass,isBeenSet, bookedAll, unknown
    
    var text: String? {
        var str: String?
        switch self {
        case .unknown:
            str = "--"
        case .allowToOrder:
            str = "预约课程"
        case .inOrder:
            str = "已预约"
        case .cancleOrder:
            str = "取消预约"
        case .waitSure:
            str = "待确认"
        case .deductClass:
            str = "扣课"
        case .refundClass:
            str = "退课"
        case .isBeenSet:
            str = "已结算"
        case .bookedAll:
            str = "已满员"
        }
        return str
    }
}

