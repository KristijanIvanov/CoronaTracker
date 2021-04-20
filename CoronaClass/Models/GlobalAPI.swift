//
//  GlobalAPI.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 19.4.21.
//

import Foundation

enum GlobalAPI: EndPoint {
    
    case getSummary
    
    var request: URLRequest? {
        switch self {
        case .getSummary:
            return request(forEndPoint: "/summary")
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
