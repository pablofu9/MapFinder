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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 20) {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 40, height: 40)
                    .font(.title)
                    .foregroundStyle(.red.opacity(0.6))
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
                Spacer()
            }
            .padding(.vertical, 6)
            .padding(.leading, 55)
            
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.gray.opacity(0.5))
                .padding(.horizontal, 40)
        }
    }
}

#Preview {
    SearchRowView(placeMark: CLPlacemark.example)
}
