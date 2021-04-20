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
            
            //This is the same with the line#53
//            self.parser.json(data: data) { (result: Result<T, Error>) in
//                switch result {
//                case .success(let parsedObject):
//                    completion(.success(parsedObject))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }l
            self.parser.json(data: data, completion: completion)

        }//.resume()
        task.resume()
    }
}

//protocol ParserProtocol {
//    func json<T: Decodable>(data: Data, completion: @escaping ResultsCompletion<T>)
//}

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
