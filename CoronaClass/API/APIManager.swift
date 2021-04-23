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
    typealias GlobalInfoCompletion = ((Result<Global, Error>) -> Void)
    typealias ConfirmedCasesByDayCompletion = ((Result<[ConfirmedCasesByDay], Error>) -> Void)

    let url = "https://api.covid19api.com/countries"
    
    static let shared = APIManager()
    private init() {}
 
    //MARK - Get all countries data
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

    //MARK: - Get global stats
    func getGlobalInfo(completion: @escaping GlobalInfoCompletion) {
        AF.request("https://api.covid19api.com/summary", method: .get).responseDecodable(of: GlobalResponse.self) { response  in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let globalResponse):
                completion(.success(globalResponse.global))
            }
        }
    }
    
    //MARK: - Fetch confirmed cases
    func getConfirmedCases(for country: String, from: Date? = nil, to: Date? = nil, completion: @escaping ConfirmedCasesByDayCompletion) {
        let fetchTodayDate = (from == nil && to == nil) ? Date().minus(days: 1) : nil
        var urlString = "https://api.covid19api.com/country/" + country + "/status/confirmed/live?"
        
        if let today = fetchTodayDate {
            urlString = urlString + "from=" + DateFormatter.isoFullFormatter.string(from: today)
        } else {
            urlString = urlString + "from=" + DateFormatter.isoFullFormatter.string(from: from!) + "&to=" + DateFormatter.isoFullFormatter.string(from: to!)
        }
        

//        AF.request(urlString, method: .get).responseData { response in
//            switch response.result {
//            case .success(let data):
//                do {
//                    let days = try jsonDecoder.decode([ConfirmedCasesByDay].self, from: data)
//                    completion(.success(days))
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.isoFullFormatter)

        AF.request(urlString, method: .get).responseDecodable(of: [ConfirmedCasesByDay].self, decoder: jsonDecoder) { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let casesByDay):
                completion(.success(casesByDay))
            }
        }
    }
}
