//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-12.
//

import SwiftUI
import Weather
import CoreLocation

struct CurrentWeather: View {
    var forecast: Forecast?
    var placemark: CLPlacemark?
    #if os(iOS)
    var padding: CGFloat = 50
    #else
    var padding: CGFloat = 30
    #endif
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            HStack {
                Spacer()
                if let forecast = forecast {
                    Image(systemName: forecast.symbolName)
                        .font(.largeTitle)
                        .scaleEffect(1.5)
                        .padding(.trailing, 15)
                    Text(forecast.value(for: .t) + "°")
                        .font(.largeTitle)
                        .scaleEffect(1.5)
                } else {
                    Text("Loading")
                        .font(.largeTitle)
                        .scaleEffect(1.5)
                }
                Spacer()
            }
            Text(placemark?.locality ?? "–")
                .font(.title2)
        }
        .padding(.vertical, padding)
    }
}

#if DEBUG
struct CurrentWeather_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeather(forecast: .example)
    }
}
#endif
