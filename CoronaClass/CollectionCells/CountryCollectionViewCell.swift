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
    }
}
