/*
 
 Copyright (c) 2015 - Alex Leite (al7dev)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

import Foundation

public extension Date {
    
    public func plus(seconds s: UInt) -> Date {
        return self.addComponentsToDate(seconds: Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(seconds s: UInt) -> Date {
        return self.addComponentsToDate(seconds: -Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(minutes m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(minutes m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: -Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(hours h: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(hours h: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: -Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(days d: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: Int(d), weeks: 0, months: 0, years: 0)
    }
    
    public func minus(days d: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: -Int(d), weeks: 0, months: 0, years: 0)
    }
    
    public func plus(weeks w: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: Int(w), months: 0, years: 0)
    }
    
    public func minus(weeks w: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: -Int(w), months: 0, years: 0)
    }
    
    public func plus(months m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: Int(m), years: 0)
    }
    
    public func minus(months m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: -Int(m), years: 0)
    }
    
    public func plus(years y: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: Int(y))
    }
    
    public func minus(years y: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: -Int(y))
    }
    
    fileprivate func addComponentsToDate(seconds sec: Int, minutes min: Int, hours hrs: Int, days d: Int, weeks wks: Int, months mts: Int, years yrs: Int) -> Date {
        var dc = DateComponents()
        dc.second = sec
        dc.minute = min
        dc.hour = hrs
        dc.day = d
        dc.weekOfYear = wks
        dc.month = mts
        dc.year = yrs
        return Calendar.current.date(byAdding: dc, to: self)!
    }
    
    public func midnightUTCDate() -> Date {
        var dc: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        dc.hour = 0
        dc.minute = 0
        dc.second = 0
        dc.nanosecond = 0
        dc.timeZone = TimeZone(secondsFromGMT: 0)
        return Calendar.current.date(from: dc)!
    }
    
    public static func secondsBetween(date1 d1:Date, date2 d2:Date) -> Int {
        let dc = Calendar.current.dateComponents([.second], from: d1, to: d2)
        return dc.second!
    }
    
    public static func minutesBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.minute], from: d1, to: d2)
        return dc.minute!
    }
    
    public static func hoursBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.hour], from: d1, to: d2)
        return dc.hour!
    }
    
    public static func daysBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.day], from: d1, to: d2)
        return dc.day!
    }
    
    public static func weeksBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.weekOfYear], from: d1, to: d2)
        return dc.weekOfYear!
    }
    
    public static func monthsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.month], from: d1, to: d2)
        return dc.month!
    }
    
    public static func yearsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.year], from: d1, to: d2)
        return dc.year!
    }
    
    //MARK- Comparison Methods
    
    public func isGreaterThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedDescending)
    }
    
    public func isLessThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedAscending)
    }
    
    public func isSameWith(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedSame)
    }
    
    public func isEqualTo(_ date: Date) -> Bool{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if dateFormatter.string(from: date) == dateFormatter.string(from: self) {
            return true;
        }
        return false;
    }
    
    public func isLessThenOrEqualTo(_ date: Date) -> Bool {
        if self.isLessThan(date) {
            return true
        }
        
        if self.isEqualTo(date) {
            return true
        }
        
        return false
    }
    
    public func isGreaterThanOrEqualTo(_ date: Date) -> Bool {
        if self.isGreaterThan(date) {
            return true
        }
        
        if self.isEqualTo(date) {
            return true
        }
        
        return false
    }
    
    public func getDateMinus(weeks: Int, fromDate: Date) -> Date{
        return Calendar.current.date(byAdding: .second, value: -Int(weeks)*604799, to: fromDate)!
    }
    
    public func getDatePlus(weeks: Int, fromDate: Date) -> Date{
        return Calendar.current.date(byAdding: .second, value: weeks*604799, to: fromDate)!
    }
    
    public func getDateMinus(weeks: Int) -> Date{
        return Calendar.current.date(byAdding: .second, value: -Int(weeks)*604799, to: self)!
    }
    
    public func getDatePlus(weeks: Int) -> Date{
        return Calendar.current.date(byAdding: .second, value: weeks*604799, to: self)!
    }
    
    public func monthFirstDate() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        var result = DateComponents()
        result.day = 1
        result.month = components.month
        result.year = components.year
        result.hour = 12
        result.minute = 0
        result.second = 0
        return calendar.date(from: result)!
    }
    //MARK- Computed Properties
    
    public var day: UInt {
        return UInt(Calendar.current.component(.day, from: self))
    }
    
    public var month: UInt {
        return UInt(NSCalendar.current.component(.month, from: self))
    }
    
    public var year: UInt {
        return UInt(NSCalendar.current.component(.year, from: self))
    }
    
    public var hour: UInt {
        return UInt(NSCalendar.current.component(.hour, from: self))
    }
    
    public var minute: UInt {
        return UInt(NSCalendar.current.component(.minute, from: self))
    }
    
    public var second: UInt {
        return UInt(NSCalendar.current.component(.second, from: self))
    }
    
    var startOfWeek: Date {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTimeOffset)
    }
    
    var endOfWeek: Date {
        return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek)!
    }
    
    var secondWeekEnd: Date{
        return Calendar.current.date(byAdding: .second, value: 2*604799, to: self.startOfWeek)!
    }
    
    var secondWeekPlusOne: Date{
        return Calendar.current.date(byAdding: .day, value: 1, to: self.secondWeekEnd)!
    }
    
    var endDateFromTodaysWeekByTenWeeks: Date{
        return Calendar.current.date(byAdding: .second, value: 10*604799, to: self.startOfWeek)!
    }
    
    var dayString: String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self);
    }
    
    var monthString: String {
        let dateFormatter = DateFormatter();
        if Date().year  ==  self.year {
            dateFormatter.dateFormat = "MMMM"
        }else{
            dateFormatter.dateFormat = "MMMM YYYY"
        }
        return dateFormatter.string(from: self);
    }
    
    var detailedMonthString: String {
        let dateComponents = Calendar.current.component(.day, from: self)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM yyyy"
        
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .ordinal
        
        let day = numberFormatter.string(from: dateComponents as NSNumber)
        
        return day!.appending(" " + dateFormatter.string(from: self))
    }
    
    var detailedShortMonthString: String {
        let dateComponents = Calendar.current.component(.day, from: self)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM yyyy"
        
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .ordinal
        
        let day = numberFormatter.string(from: dateComponents as NSNumber)
        
        return day!.appending(" " + dateFormatter.string(from: self))
    }
    
    var shortStringDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        
        return dateFormatter.string(from: self)
    }
    
    var detailedMonthStringPlusTime: String {
        var detailedMonth = self.detailedShortMonthString;
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        detailedMonth = detailedMonth + ", " + dateFormatter.string(from: self)
        return detailedMonth
    }
    
    var customShortDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: self)
    }
    
    var customShortTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    var customWJDate: String {
        return customShortDate + " at " + customShortTime
    }
    
    var isToday: Bool {
        let today = Date()
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if dateFormatter.string(from: today) == dateFormatter.string(from: self) {
            return true;
        }
        return false;
    }
    
    var today: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self) 
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: self)
    }
	
	var longTimeString: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm:ss.SSS"
		
		return formatter.string(from: self)
	}
    
    var dayShort: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter.string(from: self)
    }
    
    var shortDate: String {
        let today = Date()
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
    
    var longDetailedDate: String {
        //EEEE, MMM d, yyyy
        let dateComponents = Calendar.current.component(.day, from: self)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE [$] MMMM yyyy"
        
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .ordinal
        
        let day = numberFormatter.string(from: dateComponents as NSNumber)
        
        return dateFormatter.string(from: self).replacingOccurrences(of: "[$]", with: day!)
    }
    
    func dateToUTCString() -> String {
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone.current
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let dateOneString = dateFormater.string(from: Date())
        let dateOne = dateFormater.date(from: dateOneString)
        dateFormater.timeZone = TimeZone(abbreviation: "UTC")
        let dateString = dateFormater.string(from: dateOne!)
        return dateString
    }
    
    
    public init(utcString: String) {
        self.init() 
    }
    
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    var timeAgoSince: String {
        let now = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let defaultTimeZoneStrForGivenDate = formatter.string(from: self)
        let defaultTimeZoneStrNow = formatter.string(from: now)
        // "2014-07-23 11:01:35 -0700" <-- same date, local, but with seconds
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = formatter.date(from: defaultTimeZoneStrForGivenDate)
        let nowDate = formatter.date(from: defaultTimeZoneStrNow)
        
        let components = Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: date!, to: nowDate!)
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
    }
    
    var timeRemainingString: String {
        let secondsFromNowToFinish = self.timeIntervalSinceNow
        let hours = Int(secondsFromNowToFinish / 3600)
        let minutes = Int((secondsFromNowToFinish - Double(hours) * 3600) / 60)
        let seconds = Int(secondsFromNowToFinish - Double(hours) * 3600 - Double(minutes) * 60 + 0.5)
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var customDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    var customDateTime: String {
        var detailedDate = self.customDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        detailedDate = detailedDate + ", " + dateFormatter.string(from: self)
        return detailedDate
    }
    
    var customDateTime1: String {
        let detailedDate = dayShort + ", " + timeString
        return detailedDate
    }
    
    var customZootchDate: String {
        return dayShortZootch + " at " + timeString()
    }
    
    var dayShortZootch: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: self)
    }
    
    func timeString(ofStyle style: DateFormatter.Style = .short, forTimezone timezone: TimeZone = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timezone
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: self)
    }
    
//    public func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "UTC") -> Date? {
//        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
//        let cal = Calendar.current
//        var components = cal.dateComponents(x, from: self)
//        
//        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
//        components.hour = hour
//        components.minute = min
//        components.second = sec
//        
//        return cal.date(from: components)
//    }
    
    func setTime(hour: Int, min: Int, sec: Int) -> Date? {
        let date = Calendar.current.date(bySettingHour: hour, minute: min, second: sec, of: self)!
        return date
    }
    
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func callsFormat() -> String {
        if self.isToday || self.isYesterday {
            let timeFormatter = DateFormatter()
            timeFormatter.timeZone = .autoupdatingCurrent
            timeFormatter.dateFormat = "hh:mm a"
            let time = timeFormatter.string(from: self)
            return (self.isYesterday ? "Yesterday" : "Today") + " at " + timeString()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        return dateFormatter.string(from: self)
    }
}

