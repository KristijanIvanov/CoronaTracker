//
//  CountryCollectionViewCell.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 13.4.21.
//

import UIKit

protocol CountryCellDelegate: AnyObject {
    func didAddLastCase(_ lastCase: ConfirmedCasesByDay, for country: Country)
}

class CountryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI elements
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblCasesNumber: UILabel!
    @IBOutlet weak var retryBtn: UIButton!
    
    //MARK: - Variables
    weak var delegate: CountryCellDelegate?
    private let api = WebServices()
    var country: Country?
    var countryDetailsConfirmed: ConfirmedCasesByDay?
    var countryDetailsRecovered: ConfirmedCasesByDay?
    var countryDetailsDeaths: ConfirmedCasesByDay?
    var status = Status(rawValue: "")
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblCasesNumber.text = ""
        lblCountryName.text = ""
        retryBtn.isHidden = true
    }

    //MARK: - IBActions
    @IBAction func retryBtnPressed(_ sender: UIButton) {
        guard let country = country else { return }
        getConfirmedCases(country)
    }
}

//MARK: - Retry mechanism
extension CountryCollectionViewCell {
    private func getConfirmedCases(_ country: Country) {
        api.request(CountryAPI.getCases(country: country, startDate: Date().minus(days: 1), endDate: Date(), status: .confirmed)) { (_ result: Result<[ConfirmedCasesByDay], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let casesByDay):
                    guard casesByDay.count > 0, let country = self.country else { return }
                    let lastCase = casesByDay[casesByDay.count - 1]//get last one
                    self.delegate?.didAddLastCase(lastCase, for: country)
                    self.configureCell(countryConfirmedCase: lastCase)
                }
            }
        }
    }
}

//MARK: - UI Config
extension CountryCollectionViewCell {
    func setupCell() {
        retryBtn.isHidden = true
        shadowView.layer.cornerRadius = 8
        shadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        shadowView.layer.shadowOpacity = 1.0
        shadowView.layer.shadowRadius = 8
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    func configureCell(country: Country) {
        retryBtn.isHidden = false
        self.country = country
        lblCountryName.text = country.name
    }
    
    func configureCell(countryConfirmedCase: ConfirmedCasesByDay) {
        retryBtn.isHidden = true
        lblCountryName.text = countryConfirmedCase.countryName
        lblCasesNumber.text = "\(countryConfirmedCase.cases.getFormattedNumber())"
        countryDetailsConfirmed = countryConfirmedCase
    }
}

