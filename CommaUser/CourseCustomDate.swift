//
//  CourseCustomDate.swift
//  CommaUser
//
//  Created by Marco Sun on 2018/4/17.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import Foundation

protocol CourseCustomDate {
    var date: String? { get set }
    var week: String? { get set }
    var start_time: String? { get set }
    var end_time: String? { get set }
}

protocol CourseBooking {
    var people_num: String? { get set }
    var booked_num: String? { get set }
}

extension CourseCustomDate {
    
    var wholeDate: String? {
        guard let date = self.date,
            let week = self.week,
            let start = start_time,
            let end = end_time,
            let weekNum = Int(week) else {
                return nil
        }
        let weekZN = CalendarManager.tranformWeekToChineseCharacter(week: weekNum, prefix: "周")
        return date + " " + weekZN + " " + start + "~" + end
    }
}

extension CourseBooking {
    var wholeAmount: String? {
        guard let booked = self.booked_num,
            let people = self.people_num else {
                return nil
        }
        if booked == people,
            String.isNotEmptyString(booked) {
            return "约满"
        }
        return booked + "/" + people
    }
    
    var isBookedAll: Bool {
        
        if String.isNotEmptyString(booked_num),
            booked_num == people_num {
            return true
        }
        return false
    }
}
