//
//  WeatherView.swift
//  Shared
//
//  Created by Maximilian Wendel on 2021-02-07.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var model: WeatherModel
    @State private var isShowingDetailView: Bool = false
    
    @Preference(key: "dismissedLocationAuthorization")
    private var dismissedLocationAuthorization: Bool
    
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
                    if let forecast = model.forecast {
                        CurrentWeather(forecast: model.forecast, placemark: model.placemark)
                            .overlay(
                                Button(action: {
                                    isShowingDetailView = true
                                }, label: {
                                    Image(systemName: "chevron.compact.right")
                                        .font(.title)
                                        .frame(width: 50, height: 100)
                                })
                                .buttonStyle(BorderlessButtonStyle()
                            ), alignment: .trailing)
                            .overlay(
                                NavigationLink(
                                    destination:  WeatherDetail(forecast: forecast),
                                    isActive: $isShowingDetailView,
                                    label: { EmptyView() }
                                ).hidden()
                            )
                    }
                    
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
