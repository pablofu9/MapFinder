//
//  MapFinderApp.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 13/6/24.
//

import SwiftUI

@main
struct MapFinderApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}

