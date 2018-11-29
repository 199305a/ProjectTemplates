//
//  CourseItemInfoModel.swift
//  CommaUser
//
//  Created by macbook on 2018/10/26.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit

class CourseItemInfoModel: BaseModel {
    var course_name:String?
    var course_reservation_status:Int = InvalidInteger
    var orderStatus: LittleGourpCourseOrderStatus {
        return LittleGourpCourseOrderStatus(rawValue: course_reservation_status) ?? .unknown
    }
    var course_id:String?
    var course_status: Int = InvalidInteger
    var course_images:[String] = []
    var person_max:String?
    var course_tag:[String] = []
    var trainer:String?
    var is_fee: Int = InvalidInteger
    var isFee: Bool {
        return is_fee == 1
    }
    var course_price:String?
    var intensity:String?
    var course_time:String?

    var can_reservation: Int = InvalidInteger
    var reservation_status:Int = InvalidInteger
    var full_people_status: Int = InvalidInteger
    var place:String?
    var address:String?
    var surplus_course:String?
    var surplus_course_deadline:String?
    
    var couser_desc:String?
    var course_waring:String?
    var gym_id:String?
//    var gym_address:String?
    var gym_images:[String] = []

}


