//
//  EndPoint.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 19.4.21.
//

import Foundation

protocol EndPoint {
    //http or https
    var scheme: String {get}
    
    //BASE URL (api.covid19api.com)
    var host: String {get}

    //Instead of URL we have Request because we will use URL Session
    var request: URLRequest? {get}
    
    //httpMethod
    //GET, POST, DELETE, PUT
    var httpMethod: String {get}
    
    //Content-Type: application/json
    var httpHeaders: [String: String]? {get}
    
    //Body of the request (parameters) json
    var body: [String:Any]? {get}
    
    
    //URL parametri(itemOne = valueOne, itemTwo = valueTwo)
    var queryItems: [URLQueryItem]? {get}
}

extension EndPoint {
    var scheme: String {
        return "https"
    }
    var host: String {
        return "api.covid19api.com"
    }
}

//scheme://host:/path?queryItems
//https://api.covid19api.com/countries?from=...
extension EndPoint {
    func request(forEndPoint path: String) -> URLRequest? {
        //Create URL out of separate components
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {return nil}
        
        //Set http method
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod

        //Set http headers if any
        if let httpHeaders = httpHeaders {
            httpHeaders.forEach {(key, value) in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        //Set the request body
        if let body = body {
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        }
        return request
    }
}
