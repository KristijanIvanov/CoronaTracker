//
//  CountryCollectionViewCell.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 13.4.21.
//

import UIKit

class CountryCollectionViewCell: UICollectionViewCell {
    //MARK: - UI elements
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblCasesNumber: UILabel!
    
    var country: Country?
private let api = WebServices()
    
    //MARK: - Setup cell
    func setupCell() {
        shadowView.layer.cornerRadius = 8
        shadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        shadowView.layer.shadowOpacity = 1.0
        shadowView.layer.shadowRadius = 8
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    //MARK: - Setup cell's data
    func setCountryData(_ country: Country) {
        self.country = country
        lblCountryName.text = country.name
        getConfirmedCases(country)
    }
    
    //MARK: - Fetch confirmed cases
    private func getConfirmedCases(_ country: Country) {
        api.request(CountryAPI.getConfirmedCases(country, Date().minus(days: 1), Date())) { (_ result: Result<[ConfirmedCasesByDay], Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let casesByDay):
                print(casesByDay.count)
                
                let sorted = casesByDay.sorted(by: {$0.date > $1.date })
                if let today = sorted.first {
                    self.lblCasesNumber.text = "\(today.cases)"
                }
            }
        }
        
//        APIManager.shared.getConfirmedCases(for: country.slug) { result in
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .success(let casesByDay):
//                print(casesByDay.count)
//
//                let sorted = casesByDay.sorted(by: {$0.date > $1.date })
//                if let today = sorted.first {
//                    self.lblCasesNumber.text = "\(today.cases)"
//                }
//            }
//        }
    }
}
