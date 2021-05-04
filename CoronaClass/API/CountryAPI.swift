//
//  CountryAPI.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 19.4.21.
//

import Foundation

enum Status: String {
    case confirmed = "confirmed"
    case recovered = "recovered"
    case deaths = "deaths"
    
//    var status: String {
//        switch  self {
//        case .confirmed:
//            return "confirmed"
//        case .recovered:
//            return "recovered"
//        case .deaths:
//            return "deaths"
//        }
//    }
}

enum CountryAPI: EndPoint {

    case getCases(country: Country, startDate: Date, endDate: Date, status: Status)
    case getConfirmedCasesDayOne(country: Country, status: Status)
    case getAllStatusForDayOne(country: Country)
    
    var request: URLRequest? {
        switch self {
        case .getCases(country: let country, _, _, status: let status):
            return request(forEndPoint: "/country/\(country.slug)/status/\(status)")
        
        case .getConfirmedCasesDayOne(country: let country, status: let status):
        return request(forEndPoint: "dayone/country/\(country.slug)/status/\(status)")
        
        case .getAllStatusForDayOne(country: let country):
        return request(forEndPoint: "dayone/country/\(country.slug)")
        }
    }
    
    var httpMethod: String {
        switch self {
        case .getCases,
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
        case .getCases( _, let fromDate, let toDate, _):
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
