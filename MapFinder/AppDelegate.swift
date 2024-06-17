//
//  AppDelegate.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 17/6/24.
//



import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Dependencies.shared.provideDependencies()


        return true
    }
}
