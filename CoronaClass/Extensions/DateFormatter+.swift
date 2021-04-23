//
//  DateFormatter+.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 14.4.21.
//

import Foundation

extension DateFormatter {
    static let isoFullFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
