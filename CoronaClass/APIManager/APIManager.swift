//
//  APIManager.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 7.4.21.
//

import Foundation
import Alamofire

class APIManager {
    
    typealias CountriesResultsCompletion = ((Result<[Country], Error>) -> Void)
    let url = "https://api.covid19api.com/countries"
    
    static let shared = APIManager()
    private init() {}
    
    func getAllCountries(completion: @escaping CountriesResultsCompletion) {
        AF.request(url).responseDecodable(of: [Country].self) { response  in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let countries):
                completion(.success(countries))
            }
        }
    }
    
    func getGlobalData(completion: @escaping(_ globalData: Content?, _ error: Error?) -> Void) {
        let url = "https://api.covid19api.com/summary"
        let headers: HTTPHeaders = ["X-Access-Token" : "5cf9dfd5-3449-485e-b5ae-70a60e997864"]
        
        AF.request(url, headers: headers).responseDecodable(of: Content.self) { response in
            switch response.result {
            case .failure(let error):
                completion(nil, error)
            case .success(let global):
                completion(global, nil)
            }
        }
    }
}
