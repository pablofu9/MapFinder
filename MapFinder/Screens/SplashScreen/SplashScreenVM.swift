//
//  SplashScreenVM.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 17/6/24.
//

import Foundation
import SwiftUI

final class SplashScreenVM: ObservableObject {
    
    // MARK: - Published properties
    @Published var synchronizing = false
    @Published var initialSynchCompleted = false
    @Published var initialSynchFailed = false
    
    // MARK: - Private properties
    private let interactor = SplashScreenInteractor()
    
    // MARK: - Public methods
    /// Initial sync
    @MainActor func initialSynch() async {
        synchronizing = true
        do {
            try await interactor.initialSynch()
            
            initialSynchCompleted = true
        } catch {

            print("Error doing initial synch: \(error)")
        }
        
        initialSynchFinished()
    }

    // MARK: - Private methods
    /// Initial sync finished
    private func initialSynchFinished() {
        initialSynchFailed = !initialSynchCompleted
        synchronizing = false
    }
}
