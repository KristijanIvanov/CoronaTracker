//
//  CountriesAPI.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 19.4.21.
//

import Foundation

enum CountriesAPI: EndPoint {
    
    case getAllCountries

    var request: URLRequest? {
        switch self {
        case .getAllCountries:
            return request(forEndPoint: "/countries")
        }
        
    }
    
    var httpMethod: String {
        return "GET"
    }
    
    var httpHeaders: [String : String]? {
        return nil
    }
    
    var body: [String : Any]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
