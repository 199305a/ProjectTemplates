 //
//  CalendarManager.swift
//  LikingManager
//
//  Created by Marco Sun on 16/10/8.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit

class CalendarManager: NSObject {
    
    static let calendar: Calendar = {
        var c = Calendar.init(identifier: Calendar.Identifier.gregorian)
        c.firstWeekday = 2
        c.timeZone = timeZone
        return c
    }()
    
    static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM"
        f.timeZone = timeZone
        
        return f
    }()
    
    
    /// 获取当前月内有多少天
    static var numberOfDaysInMonth: Int {
        let date = Foundation.Date()
        let range = (calendar as NSCalendar).range(of: .day, in: .month, for: date)
        return range.length
    }
    
    /// 获取当前月第一天的日期
    static var firstDayOfCurrentMonth: Foundation.Date {
        var date = Date()
        var timeInterval: TimeInterval = 0
        let ok = calendar.dateInterval(of: .month, start: &date, interval: &timeInterval, for: date)
        assert(ok, "Failed to calculate the first day of the month based on %@")
        return date
    }
    
    /// 返回当天在一周内的星期
    static var weeklyOrdinality: Int {
        return (calendar as NSCalendar).ordinality(of: .day, in: .weekOfMonth, for: Foundation.Date())
    }
    
    // 获取指定月的每一天的星期
    static var obtainAllDaysAndWeekdaysForCurrentMonth: [Int] {
        let date = Foundation.Date()
        let dateStr = formatter.string(from: date)
        return obtainAllDaysAndWeekdaysForMonth(dateStr)
    }
    
    /// 获取指定月内有多少天
    class func numberOfDaysInMonth(_ date: String) -> Int {
        let date = formatter.date(from: date)
        guard let _ = date else { return 0 }
        let range = (calendar as NSCalendar).range(of: .day, in: .month, for: date!)
        return range.length
    }
    
    /// 指定月的第一天的日期
    class func firstDayOfMonth(_ date: String) -> Foundation.Date {
        let d = formatter.date(from: date)
        assert(d != nil, "wrong date string")
        var date: Foundation.NSDate? = nil
        let ok = (calendar as NSCalendar).range(of: .month, start: &date, interval: nil, for: d!)
        assert(ok, "Failed to calculate the first day of the month based on %@")
        return date! as Date
    }
    
    /// 返回某日期的星期
    class func weeklyOrdinality(_ date: Foundation.Date) -> Int {
        return (calendar as NSCalendar).ordinality(of: .day, in: .weekOfMonth, for: date)
    }
    
    // 获取指定月的每一天的星期
    class func obtainAllDaysAndWeekdaysForMonth(_ date: String) -> [Int] {
        let num = numberOfDaysInMonth(date)
        let firstDay = firstDayOfMonth(date)
        let firstWeekday = weeklyOrdinality(firstDay)
        
        var weekDay = [Int]()
        for index in 0...num - 1 {
            var week = (index + firstWeekday) % 7
            if week == 0 {
                week = 7
            }
            weekDay.append(week)
        }
        return weekDay
    }
    
    /// 获取指定格式的星期数组
    class func obtainStandardFormatterWeekdays(_ weekdays: [Int], style: WeekStyle = .default) -> [String] {
        let styles = style.obtainStyleDataSource()
        var newWeekdays = [String]()
        weekdays.forEach { week in
            newWeekdays.append(styles[week - 1])
        }
        return newWeekdays
    }
    
    /// 获取指定格式的月份
    class func obtainDateString(_ date: Foundation.Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyyMM"
        f.timeZone = timeZone
        return f.string(from: date)
    }
    
    class func obtainLastMonthString(_ date: Foundation.Date) -> String {
        let comp = (calendar as NSCalendar).components([.year, .month], from: date)
        var month: Int!
        var year: Int = comp.year!
        if comp.month == 1 {
            month = 12
            year -= 1
        } else {
            month = comp.month! - 1
        }
        return String.init(format: "%d%.2d", year,month)
        
    }
}

enum WeekStyle: Int {
    case `default`
    
    func obtainStyleDataSource() -> [String] {
        var styles: [String]!
        switch self {
        case .default:
            styles = [Text.Mon, Text.Tue, Text.Wed, Text.Thu, Text.Fri, Text.Sat, Text.Wee]
        }
        return styles
    }
}

private let timeZone = TimeZone.init(abbreviation: "UTC")!

extension CalendarManager {
    
    @nonobjc static let localFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    /** 获取本周第一天的日期 */
    class func firstDayOfThisWeek() -> Foundation.Date {
        let calendar = Calendar.current
        let now = Foundation.Date()
        let component = (calendar as NSCalendar).components(.weekday, from: now)
        let divDay = component.weekday! - 2
        let date = now.addingTimeInterval(-Double(divDay)*24*3600)
        
        return date
    }
    
    /** 获取本月第一天的日期 */
    class func firstDayOfThisMonth() -> Foundation.Date {
        let calendar = Calendar.current
        var component = (calendar as NSCalendar).components([.year,.month,.day,.hour,.weekday], from: Foundation.Date())
        component.day = 1
        let date = calendar.date(from: component)
        return date!
    }
    
    /** 获取近n月的日期 */
    class func firstDayOfNearMonths(_ n: Int) -> Foundation.Date {
        
        assert(n<12, "please input n < 12")
        let calendar = Calendar.current
        var component = (calendar as NSCalendar).components([.year,.month,.day,.hour,.weekday], from: Foundation.Date())
        let tempMonth = component.month! - n + 1
        if tempMonth > 0 {
            component.month = tempMonth
        } else {
            component.year! -= 1
            component.month = 12 + tempMonth
        }
        
        component.day = 1
        
        let date = calendar.date(from: component)
        
        return date!
    }
    
    /** 获取当前月份 */
    class func currentMonthDay() -> (month:Int,day:Int) {
        let calendar = Calendar.current
        let component = (calendar as NSCalendar).components([.month,.day], from: Foundation.Date())
        return (component.month!,component.day!)
    }
    
    /** 获取当前年月日 */
    class func currentYearMonthDay() -> (year:Int,month:Int,day:Int) {
        let calendar = Calendar.current
        let component = (calendar as NSCalendar).components([.year,.month,.day], from: Date())
        return (component.year!,component.month!,component.day!)
    }
    
    /** 获取某个日期的年月日 */
    class func getYearMonthDayWithDate(date: Date) -> (year:Int?,month:Int?,day:Int?) {
        let calendar = Calendar.current
        let component = (calendar as NSCalendar).components([.year,.month,.day], from: date)
        return (component.year,component.month,component.day)
    }
    
    class func tranformWeekToChineseCharacter(week: Int ,prefix: String = "") -> String {
        let arr = ["日", "一", "二", "三", "四", "五", "六"]
        return prefix + arr[week%7]
    }

}
