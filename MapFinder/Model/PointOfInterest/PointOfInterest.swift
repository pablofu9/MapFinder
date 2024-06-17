//
//  PointOfInterest.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 14/6/24.
//

import Foundation
import MapKit
import SwiftUI

enum PointOfInterestCategory: String, CaseIterable {
    case airport = "MKPOICategoryAirport"
    case amusementPark = "MKPOICategoryAmusementPark"
    case aquarium = "MKPOICategoryAquarium"
    case atm = "MKPOICategoryATM"
    case bakery = "MKPOICategoryBakery"
    case bank = "MKPOICategoryBank"
    case beach = "MKPOICategoryBeach"
    case brewery = "MKPOICategoryBrewery"
    case cafe = "MKPOICategoryCafe"
    case campground = "MKPOICategoryCampground"
    case carRental = "MKPOICategoryCarRental"
    case evCharger = "MKPOICategoryEVCharger"
    case fireStation = "MKPOICategoryFireStation"
    case fitnessCenter = "MKPOICategoryFitnessCenter"
    case foodMarket = "MKPOICategoryFoodMarket"
    case gasStation = "MKPOICategoryGasStation"
    case hospital = "MKPOICategoryHospital"
    case hotel = "MKPOICategoryHotel"
    case laundry = "MKPOICategoryLaundry"
    case library = "MKPOICategoryLibrary"
    case marina = "MKPOICategoryMarina"
    case movieTheater = "MKPOICategoryMovieTheater"
    case museum = "MKPOICategoryMuseum"
    case nationalPark = "MKPOICategoryNationalPark"
    case nightlife = "MKPOICategoryNightlife"
    case park = "MKPOICategoryPark"
    case parking = "MKPOICategoryParking"
    case pharmacy = "MKPOICategoryPharmacy"
    case police = "MKPOICategoryPolice"
    case postOffice = "MKPOICategoryPostOffice"
    case publicTransport = "MKPOICategoryPublicTransport"
    case restaurant = "MKPOICategoryRestaurant"
    case restroom = "MKPOICategoryRestroom"
    case school = "MKPOICategorySchool"
    case stadium = "MKPOICategoryStadium"
    case store = "MKPOICategoryStore"
    case theater = "MKPOICategoryTheater"
    case university = "MKPOICategoryUniversity"
    case winery = "MKPOICategoryWinery"
    case zoo = "MKPOICategoryZoo"
    case unknown

    var imageName: String {
        switch self {
        case .airport: return "airplane"
        case .amusementPark: return "figure.standing.line.dotted.figure.standing"
        case .aquarium: return "fish"
        case .atm: return "banknote"
        case .bakery: return "cup.and.saucer"
        case .bank: return "banknote"
        case .beach: return "sun.max"
        case .brewery: return "beer"
        case .cafe: return "cup.and.saucer"
        case .campground: return "tent"
        case .carRental: return "car"
        case .evCharger: return "bolt.car"
        case .fireStation: return "flame"
        case .fitnessCenter: return "dumbbell"
        case .foodMarket: return "cart"
        case .gasStation: return "fuelpump"
        case .hospital: return "cross"
        case .hotel: return "bed.double"
        case .laundry: return "washer"
        case .library: return "books.vertical"
        case .marina: return "sailboat"
        case .movieTheater: return "film"
        case .museum: return "paintbrush"
        case .nationalPark: return "tree"
        case .nightlife: return "music.note"
        case .park: return "leaf"
        case .parking: return "parkingsign"
        case .pharmacy: return "cross.vial"
        case .police: return "shield"
        case .postOffice: return "mailbox"
        case .publicTransport: return "bus"
        case .restaurant: return "fork.knife"
        case .restroom: return "toilet"
        case .school: return "graduationcap"
        case .stadium: return "sportscourt"
        case .store: return "basket"
        case .theater: return "theatermasks"
        case .university: return "books.vertical"
        case .winery: return "wineglass"
        case .zoo: return "tortoise"
        case .unknown: return "map"
        }
    }
    var color: Color {
        switch self {
        case .airport: return .gray
        case .amusementPark: return .green
        case .aquarium: return .blue
        case .atm: return .gray
        case .bakery: return .red
        case .bank: return .gray
        case .beach: return .yellow
        case .brewery: return .gray
        case .cafe: return .black
        case .campground: return .gray
        case .carRental: return .gray
        case .evCharger: return .green
        case .fireStation: return .red
        case .fitnessCenter: return .accentColor
        case .foodMarket: return .brown
        case .gasStation: return .gray
        case .hospital: return .gray
        case .hotel: return .gray
        case .laundry: return .gray
        case .library: return .gray
        case .marina: return .mint
        case .movieTheater: return .gray
        case .museum: return .gray
        case .nationalPark: return .green
        case .nightlife: return .red
        case .park: return .green
        case .parking: return .gray
        case .pharmacy: return .red
        case .police: return .red
        case .postOffice: return .gray
        case .publicTransport: return .gray
        case .restaurant: return .brown
        case .restroom: return .gray
        case .school: return .green
        case .stadium: return .green
        case .store: return .gray
        case .theater: return .gray
        case .university: return .gray
        case .winery: return .red
        case .zoo: return .green
        case .unknown: return .gray
        }
    }
    
    

    static func fromString(_ string: String) -> PointOfInterestCategory? {
        return PointOfInterestCategory(rawValue: string)
    }
}

// Ejemplo de uso:

// Aquí se obtiene el primer punto de interés de la lista del LocationManager y se pasa a la vista SearchRowView

