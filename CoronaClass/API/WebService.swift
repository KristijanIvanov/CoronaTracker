//
//  WebService.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 19.4.21.
//

import Foundation

typealias ResultsCompletion<T> = (Result<T, Error>) -> Void

protocol WebServiceProtocol {
    func request<T: Decodable>(_ endPoint: EndPoint, completion: @escaping ResultsCompletion<T>)
}

class WebServices: WebServiceProtocol {

    let urlSession: URLSession
    
    //Parser to parse the data response
    private let parser: Parser
    
    //We need to parse the data

    init(urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default), parser: Parser = Parser()) {
        self.urlSession = urlSession
        self.parser = parser
    }
    
    func request<T: Decodable>(_ endPoint: EndPoint, completion: @escaping ResultsCompletion<T>) {
        guard let request = endPoint.request else {
            print("request is nil")
            return}
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                //Not authorised to do this request
            }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {return}
            print("Missing data")
            
            self.parser.json(data: data, completion: completion)

        }
        task.resume()
    }
}

struct Parser {
    private let jsonDecoder = JSONDecoder()
    
    func json<T: Decodable>(data: Data, completion: @escaping ResultsCompletion<T>) {
        do {
            let result = try jsonDecoder.decode(T.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
}

//https://api.covid19api.com/country/algeria/status/confirmed?from=2021-04-22T10:26:38+0000&to=2021-04-23T10:26:38+0000
//https://api.covid19api.com/country/algeria/status/confirmed?from=2020-03-01T00:00:00Z&to=2020-04-01T00:00:00Z
