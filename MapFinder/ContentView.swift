//
//  ContentView.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 13/6/24.
//

import SwiftUI
import MapKit
import Combine

struct ContentView: View {
    
    // MARK: - Properties
    @StateObject var locationManager: LocationManager = .init()
    @State private var isPresented: Bool = false
    @State private var offset: CGFloat = .zero
    @State private var isExpanded: Bool = true
    @State private var keyboardHeight: CGFloat = 0
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State var selectedPlace: Place?
    @State var seeFavPlaces: Bool = false
    
    // MARK: - Init
    init() {
        UISearchBar.appearance().setImage(searchBarImage(), for: .search, state: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white.withAlphaComponent(0.6)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        UISearchBar.appearance().tintColor = .red.withAlphaComponent(0.6)
    }
    
    // MARK: - Body
    var body: some View {
        content
            .fullScreenCover(isPresented: $seeFavPlaces, content: {
                FavoritesView()
                    .environmentObject(locationManager)
            })
    }
    
    // MARK: - Subviews
    /// Content view
    @ViewBuilder
    private var content: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                
                MapView()
                    .environmentObject(locationManager)
                    .onTapGesture {
                        withAnimation(.linear.delay(0.2)) {
                            locationManager.fetchedPlaces.removeAll()
                            isPresented = false
                        }
                    }
                let places = locationManager.fetchedPlaces
                if places.isEmpty {
                    bottomCardViewOrButton
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                }
             
              
                VStack {
                    HStack {
                        Spacer()
                        favButton
                            .padding(.top, UIScreen.main.bounds.height / 5)
                    }
                    .padding(.trailing, 20)
                    let places = locationManager.fetchedPlaces
                    if  !places.isEmpty {
                            VStack(alignment: .leading) {
                                
                                List {
                                    Section {
                                        ForEach(places, id: \.id) { place in
                                            getListButton(place: place)
                                        }
                                        .listRowBackground(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white.opacity(0.8))
                                                .padding(2)
                                        )
                                    } header: {
                                        Text("Results")
                                            .foregroundStyle(.black.opacity(0.7))
                                    }
                                   
                                }
                                .safeAreaInset(edge: .bottom) {
                                    EmptyView()
                                        .frame(height: safeAreaInsets.bottom)
                                }
                                .padding(.top, UIScreen.main.bounds.height / 7)
                                .scrollContentBackground(.hidden)
                                .background(Color.gray.opacity(0.5).edgesIgnoringSafeArea(.all))
                            }
                            .opacity(locationManager.searchText.isEmpty ? 0 : 1)
                            .padding(.bottom, keyboardHeight - 50)
                    }
                }
                .searchable(text: $locationManager.searchText, isPresented: $isPresented)
                .frame(maxHeight: .infinity, alignment: .top)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                       currentLocationButton
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        goFavView
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                self.keyboardHeight = keyboardHeight
            }
           
        }
        .ignoresSafeArea()
    }
    
    /// Button to go to current location
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
    private var goFavView: some View {
        Button {
            withAnimation(.interactiveSpring(duration: 0.5, extraBounce: 2)) {
                seeFavPlaces.toggle()
            }
        } label: {
            HStack {
                Image(systemName: "star.fill")
                    .renderingMode(.template)
                    .foregroundStyle(.yellow)
                Text("Favorites")
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
    
    /// Bottom card view when item selected
    @ViewBuilder
    func bottomCard(placeMark: CLPlacemark) -> some View {
        VStack(spacing: 10) {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 2)
                .padding(.horizontal, 25)
                .offset(y: -7)
            Text(placeMark.name ?? "")
            HStack(spacing: 4) {
                Text("\(placeMark.postalCode ?? ""), \(placeMark.administrativeArea ?? ""), \(placeMark.country ?? "")")
           
            }
            moreInfoButton
           Spacer()
        }
       
        .frame(maxWidth: .infinity, maxHeight: 250)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.9))
                .shadow(color: .black.opacity(0.3), radius: 5)
        }
        .gesture(createDragGesture(isExpanded: $isExpanded))
        
    }
    
    /// Button to reset offset of the bottom card
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
                        .fill(.green)
                }
        }
    }
    
    /// Bottom card or button to show more info
    @ViewBuilder
    private var bottomCardViewOrButton: some View {
        if let place = locationManager.pickedPlaceMark {
            ZStack {
                bottomCard(placeMark: place)
                    .offset(y: offset)
                if !isExpanded {
                    VStack {
                        Spacer()
                        buttonToResetOffset
                    }
                    .padding(.bottom, safeAreaInsets.bottom)
                }
            }
        }
    }
    
    /// Button that we use in the list to set the place selected
    @ViewBuilder
    private func getListButton(place: Place) -> some View {
        Button {
            if let coordinate = place.placemark.location?.coordinate {
                
                setPlaceInMap(coordinate: coordinate)
                withAnimation(.linear.delay(0.2)) {
                    locationManager.searchText = ""
                    isPresented = false
                    selectedPlace = place
                    
                }
            }
        } label: {
            let category = PointOfInterestCategory.fromString(place.category.rawValue) ?? .unknown

            SearchRowView(placeMark: place.placemark, pointOfInterestCategorie: category)
        }
    }

    /// More info button of the bottom card
    @ViewBuilder
    private var moreInfoButton: some View {
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
    
    /// Favorite button
    @ViewBuilder
    private var favButton: some View {
        if let selectedPlace = selectedPlace, locationManager.fetchedPlaces.isEmpty {
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    locationManager.manageFavorite(place: selectedPlace)
                }
            } label: {
                Image(systemName: locationManager.placeIsFavorite(place: selectedPlace) ? "star.fill" : "star")
                    .resizable()
                    .scaleEffect(1)
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.yellow)
                    .background(
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white.opacity(0.7))
                    )
                
            }
        }
    }
    
    // MARK: - Private functions
    /// Create drag gesture function
    private func createDragGesture(isExpanded: Binding<Bool>) -> some Gesture {
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
    
    
    /// Image of the search bar
    private func searchBarImage() -> UIImage {
        let image = UIImage(systemName: "magnifyingglass")
        return image!.withTintColor(UIColor(.black).withAlphaComponent(0.6), renderingMode: .alwaysOriginal)
    }
    
    /// Function to set the place in the map
    private func setPlaceInMap(coordinate: CLLocationCoordinate2D) {
        locationManager.removeAnnotations()
        locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
        locationManager.addDraggablePin(coordinate: coordinate)
        locationManager.updatePlaceMark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
        
    }
}

#Preview {
    ContentView()
}

#Preview {
    ContentView().bottomCard(placeMark: .example)
}
