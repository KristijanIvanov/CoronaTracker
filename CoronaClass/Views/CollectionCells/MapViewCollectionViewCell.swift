//
//  MapViewCollectionViewCell.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 5.5.21.
//

import UIKit

protocol MapViewCollectionCellDelegate: AnyObject {
    func didPressMapButton()
}

class MapViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var flagImage: UIImageView!
    
    weak var delegate: MapViewCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = .white
        flagImage.makeRounded()
    }

    @IBAction func viewMapButton(_ sender: UIButton) {
        delegate?.didPressMapButton()
    }
}
