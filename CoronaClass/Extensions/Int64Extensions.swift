//
//  Int64Extensions.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 13.4.21.
//

import Foundation

extension Int64 {
    func getFormattedNumber() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        let string = formatter.string(from: NSNumber(value: self))
        return string ?? ""
    }
}
