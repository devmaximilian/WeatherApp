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
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                Text("\(forecast.date) – Hello, World!")
            }
        }
        .navigationTitle(forecast.date)
    }
}

#if DEBUG
struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetail(forecast: .example)
    }
}
#endif
