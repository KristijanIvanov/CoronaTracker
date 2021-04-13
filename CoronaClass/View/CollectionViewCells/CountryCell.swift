//
//  CountryCell.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 8.4.21.
//

import UIKit

class CountryCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblCountryConfirmedNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    func configureCell(with country: MockCountry) {
        lblCountry.text = country.name
        lblCountryConfirmedNumber.text = "\(country.totalConfirmed)"
    }
}
