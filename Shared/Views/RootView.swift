//
//  WeatherView.swift
//  Shared
//
//  Created by Maximilian Wendel on 2021-02-07.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var model: WeatherModel
    
    private let sourceURL = URL(string: "https://smhi.se")!
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                    // Current weather
                    CurrentWeather(forecast: model.forecast, placemark: model.placemark)
                    
                    // List of upcoming weather
                    ForEach(model.upcoming) { forecast in
                        UpcomingWeatherCell(forecast: forecast)
                    }
                    HStack(spacing: 4) {
                        Spacer()
                        Text("Source:")
                        Link("SMHI", destination: sourceURL)
                        Spacer()
                    }
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
        .onAppear(
            perform: model.update
        )
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(WeatherModel())
    }
}
