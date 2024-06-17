//
//  SplashScreenView.swift
//  FastTeamIOs
//
//  Created by Pablo Fuertes on 6/6/24.
//

import SwiftUI
import Lottie

struct SplashScreenView: View {
    
    @StateObject var splashScreenVM = SplashScreenVM()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                ZStack(alignment: .center) {
                    
                    Color.white
                    logoIcon
                }
               
                .navigationDestination(isPresented: $splashScreenVM.initialSynchCompleted) {
                    HomeView()
                }
                .ignoresSafeArea()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    Task {
                        await splashScreenVM.initialSynch()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Subviews
    /// Logo icon
    @ViewBuilder
    private var logoIcon: some View {
        LottieView(animation: .named("world"))
          .playing()
    }
}

#Preview {
    SplashScreenView()
}
