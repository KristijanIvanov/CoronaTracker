//
//  DoubleExtension.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 8.4.21.
//

import Foundation

extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
