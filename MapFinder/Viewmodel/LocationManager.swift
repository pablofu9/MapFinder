//
//  LocationManager.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 13/6/24.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import Combine


class LocationManager: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @Published var mapView: MKMapView = .init()
    @Published var manager: CLLocationManager = .init()
    
    
    // MARK: - Search
    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    @Published var fetchedPlaces: [Place] = []
    @Published var userLocation: CLLocation?
    
    @Published var pickedLocation: CLLocation?
    @Published var pickedPlaceMark: CLPlacemark?
    let defaultLocation = CLLocationCoordinate2D(latitude: 41.65518, longitude: -4.72372)
    
    @Published var favPlaces: [Place] {
        didSet {
            
        }
    }
    
    override init() {
        self.favPlaces = UserDefaults.standard.placesFavorties
        super.init()
        manager.delegate = self
        mapView.delegate = self
        manager.requestWhenInUseAuthorization()
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value != "" {
                    self.fetchPlaces(value: value)
                } else {
                    self.fetchedPlaces = []
                }
            })
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        mapView.addGestureRecognizer(tapGesture)
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(self.userDefaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)
        }
        
    }
    
    @objc func userDefaultsDidChange(_ notification: Notification) {
        DispatchQueue.main.async {
            self.favPlaces = UserDefaults.standard.placesFavorties
        }
    }
    
    @objc private func mapTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        setPlaceInMap(coordinate: coordinate)
    }
    
     func setPlaceInMap(coordinate: CLLocationCoordinate2D) {
        removeAnnotations()
        pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        mapView.region = .init(center: coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
        addDraggablePin(coordinate: coordinate)
        updatePlaceMark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
        
    }
    
    func fetchPlaces(value: String) {
        Task {
            do {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value
                let region = MKCoordinateRegion(
                    center: userLocation?.coordinate ?? defaultLocation,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                request.region = region
                request.resultTypes = .pointOfInterest
                let response = try await MKLocalSearch(request: request).start()
                await MainActor.run(body: {
                    self.fetchedPlaces = response.mapItems.compactMap { item -> Place? in
                        guard let category = item.pointOfInterestCategory else { return nil }
                        return Place(placemark: item.placemark, category: category)
                    }
                })
            } catch {
                await MainActor.run(body: {
                    self.fetchedPlaces = []
                })
            }
        }
    }
    
    func placeIsFavorite(place: Place) -> Bool {
        return UserDefaults.standard.placesFavorties.contains { $0.placemark.name == place.placemark.name }
    }
    
    func manageFavorite(place: Place) {
        if let index = UserDefaults.standard.placesFavorties.firstIndex(where: { $0.placemark.name == place.placemark.name }) {
            UserDefaults.standard.placesFavorties.remove(at: index)
        } else {
            UserDefaults.standard.placesFavorties.append(place)
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        // Handle errors
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            ()
        case .denied:
            ()
        case .authorizedAlways:
            manager.requestLocation()
        case .authorizedWhenInUse:
            manager.requestLocation()
        @unknown default:
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        self.userLocation = currentLocation
    }
    
    func handleLocationError() {
        
    }
    
    func addDraggablePin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Your place"
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "DELIVERY")
        marker.isDraggable = true
        marker.canShowCallout = true
        
        return marker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let newLocation = view.annotation?.coordinate else { return }
        self.pickedLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
        updatePlaceMark(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
    }
    
    func reverseLocationCoordinate(location: CLLocation) async throws -> CLPlacemark? {
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first
        return place
    }
    
    func updatePlaceMark(location: CLLocation) {
        Task {
            do {
                guard let place = try await reverseLocationCoordinate(location: location) else { return }
                await MainActor.run(body: {
                    self.pickedPlaceMark = place
                })
            } catch {
                
            }
        }
    }
    
    func removeAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
}
