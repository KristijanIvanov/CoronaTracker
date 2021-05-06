//
//  MapViewCollectionViewCell.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 5.5.21.
//

import UIKit

protocol didClickOnMapDelegate: AnyObject {
    func showMap()
}

class MapViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var flagImage: UIImageView!
    
    weak var delegate: didClickOnMapDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        flagImage.makeRounded()
    }

    @IBAction func viewMapButton(_ sender: UIButton) {
        delegate?.showMap()
    }
}
