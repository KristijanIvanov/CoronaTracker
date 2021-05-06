//
//  CountryDetailsCollectionViewCell.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 26.4.21.
//

import UIKit
import SnapKit

class CountryDetailsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var segmentedControls: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblMon: UILabel!
    @IBOutlet weak var lblTue: UILabel!
    @IBOutlet weak var lblWed: UILabel!
    @IBOutlet weak var lblThu: UILabel!
    @IBOutlet weak var lblFri: UILabel!
    @IBOutlet weak var lblSat: UILabel!
    @IBOutlet weak var lblSun: UILabel!
    @IBOutlet weak var lblConfirmeCases: UILabel!
    @IBOutlet weak var lblRecoveredCase: UILabel!
    @IBOutlet weak var lblDeathsCases: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.masksToBounds = true
        setupViews()
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.masksToBounds = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        segmentedControls.setBackgroundImage(nil, for: .normal, barMetrics: .compact)
        segmentedControls.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControls.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    }
    
    func configureCell(confirmed: ConfirmedCasesByDay, recovered: ConfirmedCasesByDay, deaths: ConfirmedCasesByDay) {
       lblConfirmeCases.text = "\(confirmed.cases.getFormattedNumber())"
        lblRecoveredCase.text = "\(recovered.cases.getFormattedNumber())"
        lblDeathsCases.text = "\(deaths.cases.getFormattedNumber())"
    }

}
