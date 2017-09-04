//
//  DateExtension.swift
//  Pods
//
//  Created by MacMini-2 on 04/09/17.
//
//

import Foundation

public extension Date {
    
    /// set to get the current year
    public var year: Int {
        get {
            let calendar = Calendar.autoupdatingCurrent
            let components = calendar.dateComponents([.year], from: self)
            
            guard let year = components.year else {
                return 0
            }
            
            return year
        }
        set {
            update(components: [.year: newValue])
        }
    }
    
    //// set to get the current month
    public var month: Int {
        get {
            let calendar = Calendar.autoupdatingCurrent
            let components = calendar.dateComponents([.month], from: self)
            
            guard let month = components.month else {
                return 0
            }
            
            return month
        }
        set {
            update(components: [.month: newValue])
        }
    }
    
    /// set to get the current day
    public var day: Int {
        get {
            let calendar = Calendar.autoupdatingCurrent
            let components = calendar.dateComponents([.day], from: self)
            
            guard let day = components.day else {
                return 0
            }
            
            return day
        }
        set {
            update(components: [.day: newValue])
        }
    }
    
    /// set to get the current hours
    public var hour: Int {
        get {
            let calendar = Calendar.autoupdatingCurrent
            let components = calendar.dateComponents([.hour], from: self)
            
            guard let hour = components.hour else {
                return 0
            }
            
            return hour
        }
        set {
            update(components: [.hour: newValue])
        }
    }
    
    /// set to get the current minute
    public var minute: Int {
        get {
            let calendar = Calendar.autoupdatingCurrent
            let components = calendar.dateComponents([.minute], from: self)
            
            guard let minute = components.minute else {
                return 0
            }
            
            return minute
        }
        set {
            update(components: [.minute: newValue])
        }
    }
    
    /// set to get the current second
    public var second: Int {
        get {
            let calendar = Calendar.autoupdatingCurrent
            let components = calendar.dateComponents([.second], from: self)
            
            guard let second = components.second else {
                return 0
            }
            
            return second
        }
        set {
            update(components: [.second: newValue])
        }
    }
    
    /// set to get the current nanosecond
    public var nanosecond: Int {
        let calendar = Calendar.autoupdatingCurrent
        let components = calendar.dateComponents([.nanosecond], from: self)
        
        guard let nanosecond = components.nanosecond else {
            return 0
        }
        
        return nanosecond
    }
    
    /// the current week
    /// - 1 - Sunday.
    /// - 2 - Monday.
    /// - 3 - Tuerday.
    /// - 4 - Wednesday.
    /// - 5 - Thursday.
    /// - 6 - Friday.
    /// - 7 - Saturday.
    public var weekday: Int {
        let calendar = Calendar.autoupdatingCurrent
        let components = calendar.dateComponents([.weekday], from: self)
        
        guard let weekday = components.weekday else {
            return 0
        }
        
        return weekday
    }
    
    /// Edit the date component
    ///
    /// - year: Year component.
    /// - month: Month component.
    /// - day: Day component.
    /// - hour: Hour component.
    /// - minute: Minute component.
    /// - second: Second component.
    public enum EditableDateComponents: Int {
        case year
        case month
        case day
        case hour
        case minute
        case second
    }
    
    /// Update the current date component.
    ///
    ///   - components: Need to update the dictionary of components and values
    public mutating func update(components: [EditableDateComponents: Int]) {
        let autoupdatingCalendar = Calendar.autoupdatingCurrent
        var dateComponents = autoupdatingCalendar.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second, .nanosecond], from: self)
        
        for (component, value) in components {
            switch component {
            case .year:
                dateComponents.year = value
            case .month:
                dateComponents.month = value
            case .day:
                dateComponents.day = value
            case .hour:
                dateComponents.hour = value
            case .minute:
                dateComponents.minute = value
            case .second:
                dateComponents.second = value
            }
        }
        
        let calendar = Calendar(identifier: autoupdatingCalendar.identifier)
        guard let date = calendar.date(from: dateComponents) else {
            return
        }
        
        self = date
    }
    
    
    /// Create a date object from year, month, and day.
    ///
    /// - Parameters:
    ///   - year: Year.
    ///   - month: Month.
    ///   - day: Day.
    ///   - hour: Hour.
    ///   - minute: Minute.
    ///   - second: Second.
    public init?(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        
        let calendar = Calendar.autoupdatingCurrent
        guard let date = calendar.date(from: components) else {
            return nil
        }
        self = date
    }
    
    /// Compare yourself to another date
    ///
    /// - Returns: True if it is the same day, otherwise it is false
    public func isSame(_ anotherDate: Date) -> Bool {
        let calendar = Calendar.autoupdatingCurrent
        let componentsSelf = calendar.dateComponents([.year, .month, .day], from: self)
        let componentsAnotherDate = calendar.dateComponents([.year, .month, .day], from: anotherDate)
        
        return componentsSelf.year == componentsAnotherDate.year && componentsSelf.month == componentsAnotherDate.month && componentsSelf.day == componentsAnotherDate.day
    }
    
    // it is today
    public func isToday() -> Bool {
        return self.isSame(Date())
    }
    
    // it was yesterday
    public static func isLastDay (dateString : String) -> Bool {
        let todayTimestamp = self.getTimestamp(dateString: today())
        let lastdayTimestamp = self.getTimestamp(dateString: dateString)
        return lastdayTimestamp == todayTimestamp-(24*60*60)
    }
    
    // Get today's date string
    public static func today() -> String {
        let dataFormatter : DateFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd"
        let now : Date = Date()
        return dataFormatter.string(from: now)
    }
    
    
    // yyyy-MM-dd format to MM month dd day
    public static func formattDay (dataString : String) -> String {
        if dataString.lengthOfString <= 0 {
            return "errorDate"
        }
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: Date = dateFormatter.date(from: dataString)!
        
        
        // Converted to xx month xx day format
        let newDateFormatter : DateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MM dd"
        return newDateFormatter.string(from: date)
    }
    
    public static func formattYYYYMMDDHHMMSS(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    
    // Get timestamp based on date
    public static func getTimestamp (dateString : String) -> TimeInterval {
        if dateString.lengthOfString <= 0 {
            return 0
        }
        let newDateStirng = dateString.appending(" 00:00:00")
        
        let formatter : DateFormatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.dateStyle = DateFormatter.Style.short
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/India")
        
        let dateNow = formatter.date(from: newDateStirng)
        
        return (dateNow?.timeIntervalSince1970)!
    }
    
    // Time stamp conversion time
    public static func timeStampToString(timeStamp:String) -> String {
        
        let string = NSString(string: timeStamp)
        let timeSta:TimeInterval = string.doubleValue
        let formatter = DateFormatter()
        formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/India")
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        return formatter.string(from: date as Date)
    }
    
    // Get the week
    public static func weekWithDateString (dateString : String) -> String{
        let timestamp = Date.getTimestamp(dateString: dateString)
        let day = Int(timestamp/86400)
        let array : Array = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
        return array[(day-3)%7]
     
    }
    
    public static func currentDayzero() -> Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        var components = calendar.dateComponents(unitFlags, from: Date())
        components.timeZone = TimeZone.current
        components.hour = 0
        components.minute = 0
        components.second = 0
        if let date = calendar.date(from: components) {
            return date
        }
        return Date()
    }
    
    public var YYYYMMDDDateString : String {
        let dateFormatter: DateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    public var HHMMDateString : String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    ///  Converts the given date structure to a formatted string.
    ///
    /// - Parameters:
    ///   - info: The Date to be formatted.
    ///   - dateSeparator: The string to be used as date separator. (Currently does not work on Linux).
    ///   - usFormat: Set if the timestamp is in US format or not.
    ///   - nanosecond: Set if the timestamp has to have the nanosecond.
    /// - Returns: Returns a String in the following format (dateSeparator = "/", usFormat to false and nanosecond to false). D/M/Y H:M:S. Example: 15/10/2013 10:38:43.
    public func description(dateSeparator: String = "/", usFormat: Bool = false, nanosecond: Bool = false) -> String {
        var description: String
        
        #if os(Linux)
            if usFormat {
                description = String(format: "%04li-%02li-%02li %02li:%02li:%02li", self.year, self.month, self.day, self.hour, self.minute, self.second)
            } else {
                description = String(format: "%02li-%02li-%04li %02li:%02li:%02li", self.month, self.day, self.year, self.hour, self.minute, self.second)
            }
        #else
            if usFormat {
                description = String(format: "%04li%@%02li%@%02li %02li:%02li:%02li", self.year, dateSeparator, self.month, dateSeparator, self.day, self.hour, self.minute, self.second)
            } else {
                description = String(format: "%02li%@%02li%@%04li %02li:%02li:%02li", self.month, dateSeparator, self.day, dateSeparator, self.year, self.hour, self.minute, self.second)
            }
        #endif
        
        if nanosecond {
            description += String(format: ":%03li", self.nanosecond / 1000000)
        }
        return description
    }
}
