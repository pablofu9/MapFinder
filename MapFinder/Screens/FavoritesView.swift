//
//  FavoritesView.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 16/6/24.
//

import SwiftUI

struct FavoritesView: View {
    
   
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        NavigationStack {
            let places = locationManager.favPlaces
            VStack {
                if !places.isEmpty {
                    VStack(alignment: .leading){
                        List {
                            Section {
                                ForEach(places) { place in
                                    getListButton(place: place)
                                        .swipeActions(allowsFullSwipe: true) {
                                            Button(role: .destructive) {
                                                do {
                                                    locationManager.manageFavorite(place: place)
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                            .tint(.red)
                                            
                                            
                                        }
                                }
                            } header: {
                                Text("Favourites")
                                    .foregroundStyle(.black.opacity(0.7))
                            }
                            
                        }
                       
                    }
                } else {
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    goBackButton
                }
            }
        }
    }
    
    @ViewBuilder
    private func getListButton(place: Place) -> some View {
        Button {
            if let coordinate = place.placemark.location?.coordinate {
                locationManager.setPlaceInMap(coordinate: coordinate)
                withAnimation(.interactiveSpring(duration: 0.5, extraBounce: 2)) {
                    locationManager.searchText = ""
                    dismiss()
                }
            }
        } label: {
            let category = PointOfInterestCategory.fromString(place.category.rawValue) ?? .unknown

            SearchRowView(placeMark: place.placemark, pointOfInterestCategorie: category)
        }
    }
    
    @ViewBuilder
    private var goBackButton: some View {
        Button {
            withAnimation(.interactiveSpring(duration: 0.5, extraBounce: 2)) {
                dismiss()
            }
        } label: {
            HStack {
                Image(systemName: "arrow.left")
                    .renderingMode(.template)
                    .foregroundStyle(.black.opacity(0.8))
                Text("Return to map")
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
}

#Preview {
    return FavoritesView()
}
