//
//  DateExtension.swift
//  Pods
//
//  Created by MacMini-2 on 04/09/17.
//
//

import Foundation

public extension Date {

    /**
     Initialize a date object using the given string.
     
     :param: dateString the string that will be used to instantiate the date object. The string is expected to be in the format 'yyyy-MM-dd hh:mm:ss a'.
     
     :returns: the NSDate object.
     */
    public init(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        let d = dateStringFormatter.date(from: dateString)
        if let unwrappedDate = d {
            self.init(timeInterval: 0, since: unwrappedDate)
        } else {
            self.init()
        }
    }


    /**
     Returns a string of the date object using the format 'yyyy-MM-dd hh:mm:ss a'.
     
     :returns: a formatted string object.
     */
    public func toString() -> String {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        return dateStringFormatter.string(from: self)
    }


    public func getCurrentUTCTimeStampe() -> TimeInterval
    {
        let date = Date()

        let dateFormatter = DateFormatter()

        //To prevent displaying either date or time, set the desired style to NoStyle.
        dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.long //Set date style

        let UTCDate = dateFormatter.string(from: date)

        let timeZone = TimeZone.autoupdatingCurrent
        let seconds: Double = Double(timeZone.secondsFromGMT(for: dateFormatter.date(from: UTCDate)!))

        return Date(timeInterval: seconds, since: dateFormatter.date(from: UTCDate)!).timeIntervalSince1970

    }

    public func getTimeStampWithDateTime() -> TimeInterval
    {
        let date = Date()

        let dateFormatter = DateFormatter()

        //To prevent displaying either date or time, set the desired style to NoStyle.
        dateFormatter.timeStyle = DateFormatter.Style.long //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.long //Set date style

        let UTCDate = dateFormatter.string(from: date)

        let timeZone = TimeZone.autoupdatingCurrent
        let seconds: Double = Double(timeZone.secondsFromGMT(for: dateFormatter.date(from: UTCDate)!))

        return Date(timeInterval: seconds, since: dateFormatter.date(from: UTCDate)!).timeIntervalSince1970
    }

    public func initializeDateWithTime(_ hrs: Int, minutes: Int) -> TimeInterval {

        let date = Date()

        let dateFormatter = DateFormatter()

        //To prevent displaying either date or time, set the desired style to NoStyle.
        dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.long //Set date style

        let UTCDate = dateFormatter.string(from: date)

        let today = dateFormatter.date(from: UTCDate)

        let gregorian: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var dateComponents = (gregorian as NSCalendar).components([.year, .month, .day], from: today!)

        dateComponents.hour = hrs
        dateComponents.minute = minutes
        let dateFormatter2 = DateFormatter()

        //To prevent displaying either date or time, set the desired style to NoStyle.
        dateFormatter2.timeStyle = DateFormatter.Style.long //Set time style
        dateFormatter2.dateStyle = DateFormatter.Style.long //Set date style

        let todayAtX = gregorian.date(from: dateComponents)

        let UTCDate2 = dateFormatter2.string(from: todayAtX!)
        let timeZone = TimeZone.autoupdatingCurrent
        let seconds: Double = Double(timeZone.secondsFromGMT(for: dateFormatter2.date(from: UTCDate2)!))

        return Date(timeInterval: seconds, since: dateFormatter2.date(from: UTCDate2)!).timeIntervalSince1970

    }


    public func getDateFromTimeStampe(_ formate: String, timestampe: String) -> String?
    {
        let dateFormater: DateFormatter = DateFormatter()
        dateFormater .dateFormat = formate

        let dateString = dateFormater .string(from: Date(timeIntervalSince1970: Double(timestampe)!))
        return dateString
    }

    public func setDateFromTimeStampe(_ formate: String, timestampe: Double) -> String?
    {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = formate
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let date = Date(timeIntervalSince1970: timestampe)

        let timeZone = TimeZone.autoupdatingCurrent
        let UTCDate = dateFormatter.string(from: date)

        let seconds: Double = Double(timeZone.secondsFromGMT(for: dateFormatter.date(from: UTCDate)!))

        let date2 = Date(timeInterval: -seconds, since: dateFormatter.date(from: UTCDate)!).timeIntervalSince1970

        return dateFormatter.string(from: Date(timeIntervalSince1970: date2))
    }

    //  Get Week day from date
    public var weekDay: Int {
        return (Calendar.current as NSCalendar).component(.weekday, from: self)
    }

    //  Get Week index of month from date
    public var weekOfMonth: Int {
        return (Calendar.current as NSCalendar).component(.weekOfMonth, from: self)
    }

    //  Get Week day name from date
    public var weekDayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }


    //  Get Month name from date
    public var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }

    //  Get Hour and Minute from date
    public func getHourAndMinute() -> (hour: Int, minute: Int) {
        let calendar = Calendar.current
        let comp = (calendar as NSCalendar).components([.hour, .minute], from: self)
        return (comp.hour!, comp.minute!)
    }

    //  Get Total count of weeks in month from date
    public func weeksInMonth() -> Int?
    {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.firstWeekday = 2 // 2 == Monday

        // First monday in month:
        var comps = DateComponents()
        comps.month = self.month
        comps.year = self.year
        comps.weekday = calendar.firstWeekday
        comps.weekdayOrdinal = 1
        guard let first = calendar.date(from: comps) else {
            return nil
        }

        // Last monday in month:
        comps.weekdayOrdinal = -1
        guard let last = calendar.date(from: comps) else {
            return nil
        }

        // Difference in weeks:
        let weeks = (calendar as NSCalendar).components(.weekOfMonth, from: first, to: last, options: [])
        return weeks.weekOfMonth! + 1
    }

    //  Get Total count of week days in month from date
    public func weekDaysInMonth() -> Int?
    {
        guard 1...12 ~= month else { return nil }

        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = DateComponents()
        components.weekday = self.weekDay
        components.weekdayOrdinal = 1
        components.month = self.month
        components.year = self.year

        if let date = calendar.date(from: components) {
            let firstDay = (calendar as NSCalendar).component(.day, from: date)
            let days = (calendar as NSCalendar).range(of: .day, in: .month, for: date).length
            return (days - firstDay) / 7 + 1
        }
        return nil
    }

    //  Get Total count of days in month from date
    public func daysInMonth() -> Int? {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return (calendar as NSCalendar).range(of: .day, in: .month, for: self).length
    }

    //  Get Time in AM / PM format
    public func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }

    //  Get Time short (i.e 12 Mar) format
    public func getTimeInShortFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: self)
    }

    //  Get Time short (i.e 12 Mar, 2016) format
    public func getTimeInFullFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        return formatter.string(from: self)
    }

    //  Get Time standard (i.e 2016-03-12) format
    public func formateBirthDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    //  Check date is after date
    public func afterDate(_ date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedAscending
    }

    //  Check date is before date
    public func beforDate(_ date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedDescending
    }

    //  Check date is equal date
    public func equalDate(_ date: Date) -> Bool {
        return (self == date)
    }

    //  Get days difference between dates
    public func daysInBetweenDate(_ date: Date) -> Int {
        var difference = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        difference = fabs(difference / 86400)
        return Int(difference)
    }

    //  Get hours difference between dates
    public func hoursInBetweenDate(_ date: Date) -> Int {
        var difference = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        difference = fabs(difference / 3600)
        return Int(difference)
    }

    //  Get minutes difference between dates
    public func minutesInBetweenDate(_ date: Date) -> Int {
        var difference = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        difference = fabs(difference / 60)
        return Int(difference)
    }

    //  Get seconds difference between dates
    public func secondsInBetweenDate(_ date: Date) -> Int {
        var difference = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        difference = fabs(difference)
        return Int(difference)
    }

    //  Get time difference between dates
    public func getDifferenceBetweenDates() -> String {
        let interval = self.timeIntervalSinceNow
        let year: Int = Int(interval) / 31536000
        var finalString = "'"
        if year >= 1 {
            if year == 1 {
                finalString += "1 year : "
            }
            else {
                finalString += "\(year) years : "
            }
        }
        let remainAfterYear = Int(interval) % 31536000
        let month = remainAfterYear / 2592000
        if month >= 1 {
            if month == 1 {
                finalString += "1 month : "
            }
            else {
                finalString += "\(month) months : "
            }
        }
        let remainAfterMonth = remainAfterYear % 2592000
        let day = remainAfterMonth / 86400
        if day >= 1 {
            if day == 1 {
                finalString += "1 day : "
            }
            else {
                finalString += "\(day) days : "
            }
        }
        let remainAfterDay = remainAfterMonth % 86400
        let hour = remainAfterDay / 3600
        if hour >= 1 {
            finalString += "\(hour)h : "
        }
        let remainAfterHour = remainAfterDay % 3600
        let minute = remainAfterHour / 60
        if minute >= 1 {
            finalString += "\(minute)m : "
        }
        let remainAfterMinute = remainAfterHour % 60
        let second = remainAfterMinute / 60
        if second >= 1 {
            finalString += "\(second)s "
        }

        return finalString
    }

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
    public static func isLastDay (dateString: String) -> Bool {
        let todayTimestamp = self.getTimestamp(dateString: today())
        let lastdayTimestamp = self.getTimestamp(dateString: dateString)
        return lastdayTimestamp == todayTimestamp - (24 * 60 * 60)
    }

    // Get today's date string
    public static func today() -> String {
        let dataFormatter: DateFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd"
        let now: Date = Date()
        return dataFormatter.string(from: now)
    }


    // yyyy-MM-dd format to MM month dd day
    public static func formattDay (dataString: String) -> String {
        if dataString.lengthOfString <= 0 {
            return "errorDate"
        }
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: Date = dateFormatter.date(from: dataString)!


        // Converted to xx month xx day format
        let newDateFormatter: DateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MM dd"
        return newDateFormatter.string(from: date)
    }

    public static func formattYYYYMMDDHHMMSS(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: dateString) ?? Date()
    }


    // Get timestamp based on date
    public static func getTimestamp (dateString: String) -> TimeInterval {
        if dateString.lengthOfString <= 0 {
            return 0
        }
        let newDateStirng = dateString.appending(" 00:00:00")

        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.dateStyle = DateFormatter.Style.short
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/India")

        let dateNow = formatter.date(from: newDateStirng)

        return (dateNow?.timeIntervalSince1970)!
    }

    // Time stamp conversion time
    public static func timeStampToString(timeStamp: String) -> String {

        let string = NSString(string: timeStamp)
        let timeSta: TimeInterval = string.doubleValue
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/India")
        let date = NSDate(timeIntervalSince1970: timeSta)

        return formatter.string(from: date as Date)
    }

    // Get the week
    public static func weekWithDateString (dateString: String) -> String {
        let timestamp = Date.getTimestamp(dateString: dateString)
        let day = Int(timestamp / 86400)
        let array: Array = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        return array[(day - 3) % 7]

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

    public var YYYYMMDDDateString: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }

    public var HHMMDateString: String {
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

    public func date_form(str: String?) -> Date? {

        return self.date_from(str: str, formatter: "yyyy-MM-dd HH:mm:ss")
    }

    public func date_from(str: String?, formatter: String?) -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        if let da_formatter = formatter {
            dateFormatter.dateFormat = da_formatter
            if let time_str = str {
                let date = dateFormatter.date(from: time_str)
                return date
            }
        }
        return nil
    }

    public func string_from(formatter: String?) -> String {

        if let format = formatter {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = format
            let date_str = dateFormatter.string(from: self)
            return date_str
        }
        return ""
    }
}
