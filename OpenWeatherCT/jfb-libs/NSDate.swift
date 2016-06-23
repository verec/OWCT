//
//  NSDate.swift
//  Wordbuzz
//
//  Created by verec on 21/02/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation

extension NSDate {

    func relativeToNow() -> String {
        let now = NSDate()
        let date = self
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        let units: NSCalendarUnit = [
            NSCalendarUnit.Year
        ,   NSCalendarUnit.Month
        ,   NSCalendarUnit.WeekOfMonth
        ,   NSCalendarUnit.Day
        ,   NSCalendarUnit.Hour
        ,   NSCalendarUnit.Minute
        ,   NSCalendarUnit.Second
        ]

        let comps : NSDateComponents = calendar.components(
                                            units
                            ,   fromDate:   date
                            ,   toDate:     now
                            ,   options:    [])

        if comps.year > 1 {
            let df = NSDateFormatter()
            df.dateFormat = "MMM-yy"
            return df.stringFromDate(date)
        } else if comps.year > 0 {
            return "1Y"
        } else if comps.month > 1 {
            return "\(comps.month)M"
        } else if comps.month > 0 {
            return "1M"
        } else if comps.weekOfMonth > 1 {
            return "\(comps.weekOfMonth)w"
        } else if comps.weekOfMonth > 0 {
            return "1w"
        } else if comps.day > 1 {
            return "\(comps.day)d"
        } else if comps.day > 0 {
            return "1d"
        } else if comps.hour > 1 {
            return "\(comps.hour)h"
        } else if comps.hour > 0 {
            return "1h"
        } else if comps.minute > 1 {
            return "\(comps.minute)m"
        } else if comps.day > 0 {
            return "1m"
        } else if comps.second > 1 {
            return "\(comps.second)s"
        } else if comps.second > 0 {
            return "1s"
        }
        return "Now"
    }
}

func <= (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSinceReferenceDate <= rhs.timeIntervalSinceReferenceDate
}

func < (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSinceReferenceDate < rhs.timeIntervalSinceReferenceDate
}

func >= (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSinceReferenceDate >= rhs.timeIntervalSinceReferenceDate
}

func > (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSinceReferenceDate > rhs.timeIntervalSinceReferenceDate
}

func == (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSinceReferenceDate == rhs.timeIntervalSinceReferenceDate
}

func != (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSinceReferenceDate != rhs.timeIntervalSinceReferenceDate
}

func - (lhs: NSDate, rhs: NSTimeInterval) -> NSDate {
    return NSDate(timeIntervalSinceReferenceDate: lhs.timeIntervalSinceReferenceDate - rhs)
}

func - (lhs: NSDate, rhs: NSDate) -> NSTimeInterval {
    return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
}


