//
//  CountryAPI.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 19.4.21.
//

import Foundation

enum CountryAPI: EndPoint {

    
    case getConfirmedCases(country: Country, startDate: Date, endDate: Date)
    case getConfirmedCasesDayOne(country: Country)
    case getAllStatusForDayOne(country: Country)
    
    var request: URLRequest? {
        switch self {
        case .getConfirmedCases(let country, _, _):
        return request(forEndPoint: "/country/\(country.slug)/status/confirmed")
        
        case .getConfirmedCasesDayOne(country: let country):
        return request(forEndPoint: "dayone/country/\(country.slug)/status/confirmed")
        
        case .getAllStatusForDayOne(country: let country):
        return request(forEndPoint: "dayone/country/\(country.slug)")
        }
    }
    
    var httpMethod: String {
        switch self {
        case .getConfirmedCases,
             .getConfirmedCasesDayOne,
             .getAllStatusForDayOne:
            return "GET"
        }
    }
    
    var httpHeaders: [String : String]? {
        return nil
    }
    
    var body: [String : Any]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getConfirmedCases( _, let fromDate, let toDate):
            var queryItems = [URLQueryItem]()
            let fromItem = URLQueryItem(name: "from", value: DateFormatter.isoFullFormatter.string(from: fromDate))
            let toItem = URLQueryItem(name: "to", value: DateFormatter.isoFullFormatter.string(from: toDate))
            queryItems.append(fromItem)
            queryItems.append(toItem)
            return queryItems
        default:
            return nil
        }
    }
}
