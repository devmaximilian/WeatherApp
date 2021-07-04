//
//  ForecastToday.swift
//  WeatherApp (iOS)
//
//  Created by Maximilian Wendel on 2021-07-04.
//

import SwiftUI

struct ForecastToday: View {
    @State var forecasts: [Weather]
    
    var body: some View {
        HStack {
            ForEach(forecasts) { forecast in
                forecastRow(forecast)
            }
        }
    }
    
    private func forecastRow(_ forecast: Weather) -> some View {
        VStack {
            Text(forecast.timeString)
                .font(.subheadline)
                .bold()
            Spacer()
            Image(systemName: forecast.conditionSymbol)
                .renderingMode(.original)
                .font(.title2)
            Spacer()
            Text("\(forecast.temperature)°")
                .font(.callout)
                .bold()
        }
        .frame(height: 100)
        .frame(minWidth: 50)
    }
}

struct ForecastToday_Previews: PreviewProvider {
    static var previews: some View {
        ForecastToday(forecasts: [
            Weather(temperature: 25, condition: .sunny),
            Weather(temperature: 26, condition: .sunny),
            Weather(temperature: 27, condition: .sunny)
        ])
    }
}
