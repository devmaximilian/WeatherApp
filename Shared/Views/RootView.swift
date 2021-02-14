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
    
    #if os(iOS)
    let minWidth: CGFloat = 250
    let spacing: CGFloat = 15
    #elseif os(watchOS)
    let minWidth: CGFloat = 200
    let spacing: CGFloat = 0
    #else
    let minWidth: CGFloat = 350
    let spacing: CGFloat = 15
    #endif
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: spacing) {
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
                .padding(spacing)
                .navigationTitle(model.forecast?.date ?? "")
            }
            .frame(minWidth: minWidth)
            
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
