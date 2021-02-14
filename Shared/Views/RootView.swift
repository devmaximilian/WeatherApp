//
//  WeatherView.swift
//  Shared
//
//  Created by Maximilian Wendel on 2021-02-07.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var model: WeatherModel

    @Preference(key: "dismissedLocationAuthorization")
    var dismissedLocationAuthorization: Bool
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                    if model.shouldRequestAuthorization {
                        LocationAuthorizationInformation {
                            model.requestAuthorization()
                            dismissedLocationAuthorization = true
                        } dismiss: {
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
            
            if let forecast = model.forecast {
                WeatherDetail(forecast: forecast)
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
