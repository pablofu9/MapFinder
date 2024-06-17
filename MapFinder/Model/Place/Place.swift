import Foundation
import MapKit
import Foundation
import SwiftUI
import Contacts

import MapKit

struct Place: Identifiable, Codable {
    var id = UUID()
    let placemark: MKPlacemark
    let category: MKPointOfInterestCategory

    enum CodingKeys: String, CodingKey {
        case id
        case placemarkData
        case category
    }
    
    init(id: UUID = UUID(), placemark: MKPlacemark, category: MKPointOfInterestCategory) {
        self.id = id
        self.placemark = placemark
        self.category = category
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let placemarkData = try container.decode(Data.self, forKey: .placemarkData)
        placemark = MKPlacemark.decode(from: placemarkData) ?? MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        category = try container.decode(MKPointOfInterestCategory.self, forKey: .category)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        if let placemarkData = placemark.encode() {
            try container.encode(placemarkData, forKey: .placemarkData)
        }
        try container.encode(category, forKey: .category)
    }
}

// Función para generar un array de lugares mock fuera del struct Place
func generateMockPlaces() -> [Place] {
    // Función de ayuda para generar MKPlacemark
    func createPlacemark(latitude: CLLocationDegrees, longitude: CLLocationDegrees, name: String) -> MKPlacemark {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let addressDict = [CNPostalAddressStreetKey: name]
        return MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
    }
    
    // Crear el array de objetos Place
    let mockPlaces: [Place] = [
        Place(placemark: createPlacemark(latitude: 40.748817, longitude: -73.985428, name: "Empire State Building"), category: .airport),
        Place(placemark: createPlacemark(latitude: 48.858844, longitude: 2.294351, name: "Eiffel Tower"), category: .aquarium),
        Place(placemark: createPlacemark(latitude: 51.500729, longitude: -0.124625, name: "Big Ben"), category: .bank),
        Place(placemark: createPlacemark(latitude: 35.689487, longitude: 139.691711, name: "Tokyo Tower"), category: .bakery),
        Place(placemark: createPlacemark(latitude: -33.856784, longitude: 151.213108, name: "Sydney Opera House"), category: .theater)
    ]
    
    return mockPlaces
}


