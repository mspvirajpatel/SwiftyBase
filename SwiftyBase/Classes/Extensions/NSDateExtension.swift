//
//  NSDateExtension.swift
//  Pods
//
//  Created by MacMini-2 on 13/09/17.
//
//

import Foundation

/// This extension add some useful functions to NSDate
public extension NSDate {
    // MARK: - Variables -
    
    /**
     The simplified date structure
     */
    public struct BFDateInformation {
        /// Year
        var year = 0
        /// Month of the year
        var month = 0
        /// Day of the month
        var day = 0
        
        /// Day of the week
        var weekday = 0
        
        /// Hour of the day
        var hour = 0
        /// Minute of the hour
        var minute = 0
        /// Second of the minute
        var second = 0
        /// Nanosecond of the second
        var nanosecond = 0
        
        //  MARK: - Init functions -
        
        /**
         Create a BFDateInformation to access date components easily
         
         - parameter year:       Year
         - parameter month:      Month
         - parameter day:        Day
         - parameter weekday:    Weekday
         - parameter hour:       Hour
         - parameter minute:     Minute
         - parameter second:     Second
         - parameter nanosecond: Nanosecond
         
         - returns: Returns the BFDateInformation instance
         */
        public init(year: Int = 0, month: Int = 0, day: Int = 0, weekday: Int = 0, hour: Int = 0, minute: Int = 0, second: Int = 0, nanosecond: Int = 0) {
            self.year = year
            self.month = month
            self.day = day
            self.weekday = weekday
            self.hour = hour
            self.minute = minute
            self.second = second
            self.nanosecond = nanosecond
        }
    }
    
    
    /**
     Get the month from today
     
     - returns: Return the month
     */
    public func month() -> NSDate {
        let calendar = NSCalendar.autoupdatingCurrent
        let unitFlags = Set<Calendar.Component>([.year, .month, ])
        
        var comp = calendar.dateComponents(unitFlags, from: self as Date)
        
        comp.setValue(1, for: .day)
        
        return calendar.date(from: comp)! as NSDate
    }
    
    /**
     Get the weekday number from self
     - 1 - Sunday
     - 2 - Monday
     - 3 - Tuerday
     - 4 - Wednesday
     - 5 - Thursday
     - 6 - Friday
     - 7 - Saturday
     
     - returns: Return weekday number
     */
    public func weekday() -> Int {
        let calendar = NSCalendar.autoupdatingCurrent
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .weekday])
        let comp = calendar.dateComponents(unitFlags, from: self as Date)
        return comp.weekday!
    }
    
    /**
     Get the weekday as a localized string from self
     - 1 - Sunday
     - 2 - Monday
     - 3 - Tuerday
     - 4 - Wednesday
     - 5 - Thursday
     - 6 - Friday
     - 7 - Saturday
     
     - returns: Return weekday as a localized string
     */
    public func dayFromWeekday() -> NSString {
        switch self.weekday() {
        case 1:
            return "SUNDAY"
            
        case 2:
            return "MONDAY"
            
        case 3:
            return "TUESDAY"
            
        case 4:
            return "WEDNESDAY"
            
        case 5:
            return "THURSDAY"
            
        case 6:
            return "FRIDAY"
            
        case 7:
            return "SATURDAY"
            
        default:
            return ""
        }
    }
    
    /**
     Private, return the date with time informations
     
     - returns: Return the date with time informations
     */
    private func timelessDate() -> NSDate {
        let calendar = NSCalendar.autoupdatingCurrent
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let comp = calendar.dateComponents(unitFlags, from: self as Date)
        return calendar.date(from: comp)! as NSDate
    }
    
    /**
     Private, return the date with time informations
     
     - returns: Return the date with time informations
     */
    private func monthlessDate() -> NSDate {
        let calendar = NSCalendar.autoupdatingCurrent
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .weekday])
        let comp = calendar.dateComponents(unitFlags, from: self as Date)
        
        return calendar.date(from: comp)! as NSDate
    }
    
    /**
     Compare self with another date
     
     - parameter anotherDate: The another date to compare as NSDate
     
     - returns: Returns true if is same day, false if not
     */
    public func isSameDay(anotherDate: NSDate) -> Bool {
        let calendar = NSCalendar.autoupdatingCurrent
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let unitFlags2 = Set<Calendar.Component>([.year, .month, .day])
        
        let components1 = calendar.dateComponents(unitFlags, from: self as Date)
        let components2 = calendar.dateComponents(unitFlags2, from: anotherDate as Date)
        
        return components1.year == components2.year && components1.month == components2.month && components1.day == components2.day
    }
    
    
    
    /**
     Get the days number between self and another date
     
     - parameter anotherDate: The another date
     
     - returns: Returns the days between the two dates
     */
    public func daysBetweenDate(anotherDate: NSDate) -> Int {
        let time: TimeInterval = self.timeIntervalSince(anotherDate as Date)
        return Int(abs(time / 60 / 60 / 24))
    }
    
    /**
     Returns if self is today
     
     - returns: Returns if self is today
     */
    public func isToday() -> Bool {
        return self.isSameDay(anotherDate: NSDate())
    }
    
    /**
     Add days to self
     
     - parameter days: The number of days to add
     
     - returns: Returns self by adding the gived days number
     */
    public func dateByAddingDays(days: Int) -> NSDate {
        return self.addingTimeInterval(TimeInterval(days * 24 * 60 * 60))
    }
    
    /**
     Get the month string from self
     
     - returns: Returns the month string
     */
    public func monthString() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        
        return dateFormatter.string(from:
            
            self as Date)
    }
    
    /**
     Get the year string from self
     
     - returns: Returns the year string
     */
    public func yearString() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        return dateFormatter.string(from: self as Date)
    }
    
    /**
     Returns date with the year, month and day only.
     
     - returns: Date after removing all components but not year, month and day
     */
    public func shortData() -> NSDate {
        let calendar = NSCalendar.autoupdatingCurrent
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        
        let comp = calendar.dateComponents(unitFlags, from: self as Date)
        
        return calendar.date(from: comp)! as NSDate
    }
    
    /**
     Check if the given date is less than self
     
     - parameter dateToCompare: Date to compare
     
     - returns: Returns a true if self is greater than the given one, otherwise false
     */
    public func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    /**
     Check if the given date is greater than self
     
     - parameter dateToCompare: Date to compare
     
     - returns: Returns a true if self is less than the given one, otherwise false
     */
    public func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    
    /**
     Get the month from today
     
     - returns: Returns the month
     */
    public static func month() -> NSDate {
        return NSDate().month()
    }
    
    /**
     Create an NSDate with other two NSDate objects.
     Taken from the first date: day, month and year.
     Taken from the second date: hours and minutes.
     
     - parameter date: The first date for date
     - parameter time: The second date for time
     
     - returns: Returns the created NSDate
     */
    public static func dateWithDatePart(date: NSDate, andTimePart time: NSDate) -> NSDate {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let datePortion: String = dateFormatter.string(from: date as Date)
        
        dateFormatter.dateFormat = "HH:mm"
        let timePortion: String = dateFormatter.string(from: time as Date)
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateTime = String(format: "%@ %@", datePortion, timePortion)
        
        return dateFormatter.date(from: dateTime)! as NSDate
    }
    
    /**
     Get the month as a localized string from the given month number
     - 1 - January
     - 2 - February
     - 3 - March
     - 4 - April
     - 5 - May
     - 6 - June
     - 7 - July
     - 8 - August
     - 9 - September
     - 10 - October
     - 11 - November
     - 12 - December
     
     - parameter month: The month to be converted in string
     
     - returns: Returns the given month as a localized string
     */
    public static func monthStringWithMonthNumber(month: Int) -> String {
        switch month {
        case 1:
            return "JANUARY"
            
        case 2:
            return "FEBRUARY"
            
        case 3:
            return "MARCH"
        case 4:
            return "APRIL"
            
        case 5:
            return "MAY"
            
        case 6:
            return "JUNE"
            
        case 7:
            return "JULY"
            
        case 8:
            return "AUGUST"
            
        case 9:
            return "SEPTEMBER"
            
        case 10:
            return "OCTOBER"
            
        case 11:
            return "NOVEMBER"
            
        case 12:
            return "DECEMBER"
            
        default:
            return ""
        }
    }
    
    /**
     Get the given BFDateInformation structure as a formatted string
     
     - parameter info:          The BFDateInformation to be formatted
     - parameter dateSeparator: The string to be used as date separator
     - parameter usFormat:      Set if the timestamp is in US format or not
     - parameter nanosecond:    Set if the timestamp has to have the nanosecond
     
     - returns: Returns a String in the following format (dateSeparator = "/", usFormat to false and nanosecond to false). D/M/Y H:M:S. Example: 15/10/2013 10:38:43
     */
    public static func dateInformationDescriptionWithInformation(info: BFDateInformation, dateSeparator: String = "/", usFormat: Bool = false, nanosecond: Bool = false) -> String {
        var description: String
        
        if usFormat {
            description = String(format: "%04li%@%02li%@%02li %02li:%02li:%02li", info.year, dateSeparator, info.month, dateSeparator, info.day, info.hour, info.minute, info.second)
        } else {
            description = String(format: "%02li%@%02li%@%04li %02li:%02li:%02li", info.month, dateSeparator, info.day, dateSeparator, info.year, info.hour, info.minute, info.second)
        }
        
        if nanosecond {
            description += String(format: ":%03li", info.nanosecond / 1000000)
        }
        
        return description
    }
    
    
    /// EZSE: Converts NSDate to String
    public func toString(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self as Date)
    }
    
    /// EZSE: Converts NSDate to String, with format
    public func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }
    
    /// EZSE: Calculates how many days passed from now to date
    public func daysInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        diff = fabs(diff/86400)
        return diff
    }
    
    /// EZSE: Calculates how many hours passed from now to date
    public func hoursInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        diff = fabs(diff/3600)
        return diff
    }
    
    /// EZSE: Calculates how many minutes passed from now to date
    public func minutesInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        diff = fabs(diff/60)
        return diff
    }
    
    /// EZSE: Calculates how many seconds passed from now to date
    public func secondsInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        diff = fabs(diff)
        return diff
    }
    
    /// EZSE: Easy creation of time passed String. Can be Years, Months, days, hours, minutes or seconds
    public func timePassed() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self as Date, to: date, options: [])
        var str: String
        
        if components.year != nil && components.year! >= 1
        {
            components.year == 1 ? (str = "year") : (str = "years")
            return "\(components.year!) \(str) ago"
        }
        else if components.month != nil && components.month! >= 1
        {
            components.month == 1 ? (str = "month") : (str = "months")
            return "\(components.month!) \(str) ago"
        }
        else if components.day != nil && components.day! >= 1
        {
            components.day == 1 ? (str = "day") : (str = "days")
            return "\(String(describing: components.day)) \(str) ago"
        }
        else if components.hour != nil && components.hour! >= 1
        {
            components.hour == 1 ? (str = "hour") : (str = "hours")
            return "\(String(describing: components.hour)) \(str) ago"
        }
        else if components.minute != nil && components.minute! >= 1
        {
            components.minute == 1 ? (str = "minute") : (str = "minutes")
            return "\(String(describing: components.minute)) \(str) ago"
        }
        else if components.second == 0
        {
            return "Just now"
        }
        else
        {
            return "\(String(describing: components.second)) seconds ago"
        }
    }
}

// MARK: - Operators -

public func >> (left: NSDate, right: NSDate) -> Bool {
    return left.isGreaterThanDate(dateToCompare: right)
}

public func << (left: NSDate, right: NSDate) -> Bool {
    return left.isLessThanDate(dateToCompare: right)
}

/// EZSE: Returns if one date is smaller than the other
public func << (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
}

public func >> (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedDescending
}

