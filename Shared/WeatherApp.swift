//
//  WeatherApp.swift
//  Shared
//
//  Created by Maximilian Wendel on 2021-02-07.
//

import SwiftUI

@main
struct WeatherApp: App {
    @ObservedObject var model = WeatherModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(model)
        }
    }
}
