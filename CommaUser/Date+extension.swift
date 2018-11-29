//
//  Date+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 16/5/17.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import Foundation

extension Date {

    func daysInBetweenDate(_ date: Date) -> Double
    {
        var diff = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        diff = fabs(diff/86400)
        return diff
    }

    func hoursInBetweenDate(_ date: Date) -> Double
    {
        var diff = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        diff = fabs(diff/3600)
        return diff
    }

    func minutesInBetweenDate(_ date: Date) -> Double
    {
        var diff = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        diff = fabs(diff/60)
        return diff
    }

    func secondsInBetweenDate(_ date: Date) -> Double
    {
        var diff = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        diff = fabs(diff)
        return diff
    }
}

extension Date {
    static func dateInRange(_ date: Date?, preDate: Date?, nextDate: Date?) -> Bool {
        guard let theDate = date, let aDate = preDate, let bDate = nextDate else  { return false }
        if (aDate as NSDate).earlierDate(bDate) == bDate { return false }
        if (aDate as NSDate).earlierDate(theDate) == aDate && (theDate as NSDate).earlierDate(bDate) ==  theDate { return true }
        return false
    }
    
    func dateEarlierThanSelf(_ date: Date) -> Bool {
        if (self as NSDate).earlierDate(date) == date { return true }
        return false
    }
}
