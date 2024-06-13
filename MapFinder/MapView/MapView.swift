//
//  MapView.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 13/6/24.
//

import Foundation
import UIKit
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @EnvironmentObject var locationManager: LocationManager
    
    func makeUIView(context: Context) -> MKMapView {
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}
