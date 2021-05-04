//
//  ConfirmedCasesByDay.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 14.4.21.
//

import Foundation

struct ConfirmedCasesByDay: Codable {
    let countryName: String
    let countryCode: String
    let lat: String
    let lon: String
    let cases: Int64
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case countryName = "Country"
        case countryCode = "CountryCode"
        case lat = "Lat"
        case lon = "Lon"
        case cases = "Cases"
        case date = "Date"
    }
}
