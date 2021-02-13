//
//  WeatherDetail.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-12.
//

import SwiftUI
import Weather

struct WeatherDetail: View {
    var forecast: Forecast
    
    var body: some View {
        VStack {
            
        }
        .navigationTitle(forecast.date)
        Text("\(forecast.date) – Hello, World!")
        
    }
}

#if DEBUG
struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetail(forecast: .example)
    }
}
#endif
