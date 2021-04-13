//
//  Global.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 10.4.21.
//

import Foundation

struct Content: Codable {
    var global: Global
    
    private enum CodingKeys: String, CodingKey {
        case global = "Global"
    }
}

struct Global: Codable {
    let newConfirmed: Double?
    let totalConfirmed: Double?
    let newDeaths: Double?
    let totalDeaths: Double?
    let newRecovered: Double?
    let totalRecovered: Double?
    let date: String


    private enum CodingKeys: String, CodingKey {
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
        case date = "Date"
    }
}
