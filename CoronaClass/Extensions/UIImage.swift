//
//  UIImage.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 5.5.21.
//

import Foundation
import UIKit

extension UIImageView {
    func makeRounded() {
        self.layer.borderWidth = 0.1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
