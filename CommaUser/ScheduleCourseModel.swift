//
//  ScheduleCourseModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class ScheduleCourseModel: BaseModel {
    
    var course_id: String = ""
    var category: String = ""
    var name: String = ""
    var tags = [String]()
    var img = [ImageModel]()
    var equipment = [String]()
    var intensity: String = ""
    var calorie_per_hour: String = ""
    var default_price: String = ""
    var desc: String = ""
    var video_duration: String = ""
    
    var timeLength: String {
        guard let duration = video_duration.intValue else {
            return ""
        }
        switch duration {
        case 0..<60:
            return "\(duration)秒"
        case 60..<3600:
            let minute = duration/60
            let second = duration-minute*60
            if second == 0 {
                return "\(minute)分钟"
            }
            return "\(minute)分钟\(second)秒"
        default:
            let hour = duration/3600
            let minute = (duration-hour*3600)/60
            let second = duration-hour*3600-minute*60
            var timeStr = "\(hour)小时"
            if minute > 0 {
                timeStr += "\(minute)分钟"
            }
            if second > 0 {
                timeStr += "\(second)秒"
            }
            return timeStr
        }
    }
}

class ImageModel: BaseModel {
    var url: String = ""
}
