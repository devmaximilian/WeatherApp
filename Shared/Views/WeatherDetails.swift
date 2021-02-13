//
//  WeatherDetails.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-12.
//

import SwiftUI
import Weather

struct WeatherDetails: View {
    var forecast: Forecast
    
    var body: some View {
        VStack {
            
        }
        .navigationTitle(forecast.date)
        Text("\(forecast.date) – Hello, World!")
        
    }
}

#if DEBUG
struct ForecastDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetails(forecast: .example)
    }
}
#endif
