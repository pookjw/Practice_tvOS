//
//  City.swift
//  Project7
//
//  Created by Jinwoo Kim on 2/11/21.
//

import Foundation
import CoreLocation

struct City: Comparable {
    var formattedName: String {
        return "\(name) (\(country))"
    }
    
    var name: String
    var country: String
    var coordinates: CLLocationCoordinate2D
    
    func matches(_ text: String) -> Bool {
        return name.localizedCaseInsensitiveContains(text) || country.localizedCaseInsensitiveContains(text)
    }
    
    static func < (lhs: City, rhs: City) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.name == rhs.name
    }
}
