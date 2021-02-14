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
   
    var padding: CGFloat = {
        #if os(iOS)
        return 50
        #else
        return 30
        #endif
    }()
    var scale: CGFloat = {
        #if os(watchOS)
        return 1
        #else
        return 1.5
        #endif
    }()
    var trailingSpace: CGFloat = {
        #if os(watchOS)
        return 5
        #else
        return 15
        #endif
    }()
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            HStack {
                Spacer()
                if let forecast = forecast {
                    Image(systemName: forecast.symbolName)
                        .font(.largeTitle)
                        .scaleEffect(scale)
                        .padding(.trailing, trailingSpace)
                    Text(forecast.value(for: .t) + "°")
                        .font(.largeTitle)
                        .scaleEffect(scale)
                } else {
                    Text("Loading")
                        .font(.largeTitle)
                        .scaleEffect(scale)
                }
                Spacer()
            }
            Text(placemark?.locality ?? "–")
                .font(.title3)
        }
        .contentShape(Rectangle())
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
