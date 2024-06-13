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
