//
//  CountryConfirmedCasesCollectionViewCellCollectionViewCell.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 8.4.21.
//

import UIKit

class CountryConfirmedCasesCollectionViewCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblCountryConfirmedNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
