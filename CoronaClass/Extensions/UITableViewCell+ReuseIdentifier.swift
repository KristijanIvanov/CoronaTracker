//
//  ReuseIdentifier.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 10.4.21.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
