//
//  ContentView.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 13/6/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var locationManager: LocationManager = .init()
    @State private var isPresented: Bool = false
    @State private var offset: CGFloat = .zero
    @State private var isExpanded: Bool = true
    
    init() {
        UISearchBar.appearance().setImage(searchBarImage(), for: .search, state: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white.withAlphaComponent(0.6)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        UISearchBar.appearance().tintColor = .red.withAlphaComponent(0.6)
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack(alignment: .bottom) {
                
                MapView()
                    .environmentObject(locationManager)
                    .onTapGesture {
                        withAnimation(.linear.delay(0.2)) {
                            isPresented = false
                        }
                    }
                if let place = locationManager.pickedPlaceMark {
                    ZStack {
                        bottomCard(placeMark: place)
                            .offset(y: offset)
                        if !isExpanded {
                            buttonToResetOffset
                                .padding(.top, 30)
                        }
                    }
                }
                VStack {
                   
                    if let places = locationManager.fetchedPlaces, !places.isEmpty {
                            VStack(alignment: .leading) {
                                ScrollView {
                                    ForEach(places, id: \.self) { place in
                                        Button {
                                            if let coordinate = place.location?.coordinate {
                                                setPlaceInMap(coordinate: coordinate)
                                                withAnimation(.linear.delay(0.2)) {
                                                    locationManager.searchText = ""
                                                    isPresented = false
                                                }
                                            }
                                        } label: {
                                            SearchRowView(placeMark: place)
                                        }
                                    }
                                }
                            }
                            .opacity(locationManager.searchText.isEmpty ? 0 : 1)
                            .padding(.vertical, 10)
                            .background {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(.white.opacity(0.5))
                                    .padding(.horizontal, 20)
                            }
                            .padding(.top, UIScreen.main.bounds.height / 7)
                            .padding(.bottom, 400)
                            
                    }
                    
                   
                }
                .searchable(text: $locationManager.searchText, isPresented: $isPresented)
                .frame(maxHeight: .infinity, alignment: .top)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                       currentLocationButton
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
           
        }
        .ignoresSafeArea()
    }
    
    private func searchBarImage() -> UIImage {
        let image = UIImage(systemName: "magnifyingglass")
        return image!.withTintColor(UIColor(.black).withAlphaComponent(0.6), renderingMode: .alwaysOriginal)
    }
    
    private func setPlaceInMap(coordinate: CLLocationCoordinate2D) {
        locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        locationManager.addDraggablePin(coordinate: coordinate)
        locationManager.updatePlaceMark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }
    
    @ViewBuilder
    private var currentLocationButton: some View{
        Button {
            
            if let coordinate = locationManager.userLocation?.coordinate {
                setPlaceInMap(coordinate: coordinate)
                withAnimation(.linear.delay(0.2)) {
                    locationManager.searchText = ""
                    isPresented = false
                }
            }
        } label: {
            HStack {
                Image(systemName: "location.north.circle.fill")
                    .renderingMode(.template)
                    .foregroundStyle(.black.opacity(0.8))
                Text("Use current location")
                    .foregroundStyle(.black.opacity(0.8))
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white.opacity(0.6))
            }
        }
    }
    
    @ViewBuilder
    func bottomCard(placeMark: CLPlacemark) -> some View {
        VStack(spacing: 10) {
            Text(placeMark.name ?? "")
            HStack(spacing: 4) {
                Text("\(placeMark.postalCode ?? ""), \(placeMark.administrativeArea ?? ""), \(placeMark.country ?? "")")
            }
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                    Text("See more info")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 10)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.green)
                       
                }
                
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: 250)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.9))
                .shadow(color: .black.opacity(0.3), radius: 5)
        }
        .gesture(createDragGesture(isExpanded: $isExpanded))
        
    }
    
    func createDragGesture(isExpanded: Binding<Bool>) -> some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 0.5)) {
                    if value.translation.height < 0 {
                        
                    } else {
                        offset = value.translation.height
                    }
                }
            }
            .onEnded { value in
                withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 0.5)) {
                    if value.translation.height < 0 {
                        isExpanded.wrappedValue = true
                    } else {
                        offset = UIScreen.main.bounds.height
                        isExpanded.wrappedValue = false
                    }
                }
            }
    }
    
    @ViewBuilder
    private var buttonToResetOffset: some View {
        Button {
            withAnimation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 0.5)) {
                isExpanded = true
                offset = .zero
            }
        } label: {
            Text("See details")
                .font(.title2)
                .foregroundStyle(.black)
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.green.opacity(0.7))
                }
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    ContentView().bottomCard(placeMark: .example)
}
