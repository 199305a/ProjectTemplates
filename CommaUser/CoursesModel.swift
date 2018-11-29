//
//  ClassModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit


// MARK: - banner
class BannerModel: BaseModel {
    var title: String?  // 名称
    var img_url: String?  // 图片 URL
    var load_url: String?  // 跳转链接
    var load_type: Int = InvalidInteger
    var bannerType: BannerType? {
        return BannerType.init(rawValue: load_type)
    }
}


class CoursesModel: BaseModel {
    var schedule_id: String?
    var course_name: String?
    var trainer_id: String?
    var course_date: String?
    var quota: String?
    var imgs: [String]?
    var tags: [String]?
    var type: Int = InvalidInteger
    var is_fee: Int = InvalidInteger
    var isFee: Bool {
        return is_fee == 1
    }
    
    var price: String?
    var phone: String?
    var desc: String?
    var gender: String?
    var classType: ClassType? {
        return ClassType.init(rawValue: type)
    }
    
    var tag_name: String?
    var course_icon: String?
}


enum ClassType: Int {
    case group = 1
    case trainer = 2
    case littleGroup = 4
}
