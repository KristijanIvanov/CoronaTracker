//
//  Country.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 7.4.21.
//

import Foundation

struct Country: Codable {
    let name: String
    let slug: String
    let isoCode: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "Country"
        case slug = "Slug"
        case isoCode = "ISO2"
    }
}

extension Country {
    var isSelected: Bool {
        return UserDefaults.standard.bool(forKey: slug)
    }
    
    func save() {
        UserDefaults.standard.setValue(true, forKey: slug)
    }
    
    func delete() {
        UserDefaults.standard.setValue(nil, forKey: slug)
    }
}
