//
//  CLPlacemark+Utils.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 13/6/24.
//

import Foundation
import SwiftUI
import MapKit
import SwiftUI
import AddressBook
import Contacts

extension CLPlacemark {
    static var example: CLPlacemark {
        let addressDictionary: [String: Any] = [
            
            CNPostalAddressStreetKey: "1 Infinite Loop",
            CNPostalAddressCityKey: "Cupertino",
            CNPostalAddressStateKey: "CA",
            CNPostalAddressPostalCodeKey: "95014",
            CNPostalAddressCountryKey: "USA",
            CNPostalAddressISOCountryCodeKey: "US"
        ]
        
        return MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.33182, longitude: -122.03118), addressDictionary: addressDictionary)
    }
}

extension MKPlacemark {
    func encode() -> Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
    
    static func decode(from data: Data) -> MKPlacemark? {
        try? NSKeyedUnarchiver.unarchivedObject(ofClass: MKPlacemark.self, from: data)
    }
}

extension MKPointOfInterestCategory: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self.init(rawValue: rawValue)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
