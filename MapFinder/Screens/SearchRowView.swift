//
//  SearchRowView.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 13/6/24.
//

import SwiftUI
import MapKit
import SwiftUI

struct SearchRowView: View {
    
    let placeMark: CLPlacemark
    let pointOfInterestCategorie: PointOfInterestCategory
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(spacing: 30) {
                Image(systemName: pointOfInterestCategorie.imageName)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
                    .font(.title)
                    .foregroundStyle(pointOfInterestCategorie.color)
                VStack(alignment: .leading,spacing: 6) {
                    Text(placeMark.name ?? "")
                        .lineLimit(1)
                        .font(.title3)
                        .foregroundStyle(.black)
                    Text(placeMark.administrativeArea ?? "")
                        .lineLimit(1)
                        .font(.body)
                        .foregroundStyle(.black)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)

    }
}

#Preview {
    SearchRowView(placeMark: CLPlacemark.example, pointOfInterestCategorie: .airport)
}
