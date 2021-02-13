//
//  WeatherView.swift
//  Shared
//
//  Created by Maximilian Wendel on 2021-02-07.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var model: WeatherModel

    @Preference(key: "dismissedLocationAuthorization_")
    var dismissedLocationAuthorization: Bool
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                    // Location authorization prompt
                    if model.shouldRequestAuthorization && dismissedLocationAuthorization == false {
                        LocationAuthorizationInformation(perform: model.requestAuthorization) {
                            dismissedLocationAuthorization = true
                        }
                    }
                    
                    // Current weather
                    CurrentWeather(forecast: model.forecast, placemark: model.placemark)
                    
                    // List of upcoming weather
                    ForEach(model.upcoming) { forecast in
                        UpcomingWeatherCell(forecast: forecast)
                    }
                    
                    // Attribution
                    SourceAttribution()
                }
                .padding(15)
                .navigationTitle(model.forecast?.date ?? "")
            }
            .frame(minWidth: 300)
            
            // Detail view
            VStack {
                Text("Detail view")
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(WeatherModel())
    }
}
