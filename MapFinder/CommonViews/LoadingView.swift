//
//  LoadingView.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 17/6/24.
//

import SwiftUI
import Lottie

struct LoadingView: View {
    
    var body: some View {
        ZStack {
            logoIcon
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.gray
                .opacity(0.6)
                .ignoresSafeArea()
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Subviews
    /// Logo icon
    @ViewBuilder
    private var logoIcon: some View {
        LottieView(animation: .named("plane"))
          .playing()
    }
}

#Preview {
    LoadingView()
}
