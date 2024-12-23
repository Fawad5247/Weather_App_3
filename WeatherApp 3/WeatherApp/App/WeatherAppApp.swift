//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Fawad Akthar on 12/22/2024.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.start()
        }
    }
}
