//
//  CountryAPI.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 19.4.21.
//

import Foundation

enum CountryAPI: EndPoint {

    
    case getConfirmedCases(_ country: Country, _ from: Date, _ to: Date)
    case getConfirmedCasesDayOne(country: Country)
    case getAllStatusForDayOne(country: Country)
    
    var request: URLRequest? {
//        //https://api.covid19api.com/country/[country-Slug]/status/confirmed/live?from=[fromDate]&to=[toDate
//
//
//
//
//
//        20:07
//        //https://api.covid19api.com/dayone/country/south-africa/status/confirmed
//        20:07
//        //https://api.covid19api.com/dayone/country/south-africa
        switch self {
        case .getConfirmedCases(let country, let fromDate, let toDate):
        return request(forEndPoint: "/[country/\(country.slug)/status/confirmed/live")
        
        case .getConfirmedCasesDayOne(country: let country):
        return request(forEndPoint: "dayone/country/\(country.slug)/status/confirmed")
        
        case .getAllStatusForDayOne(country: let country):
        return request(forEndPoint: "dayone/country/\(country.slug)/status/confirmed")
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
        case .getConfirmedCases(let country, let fromDate, let toDate):
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
