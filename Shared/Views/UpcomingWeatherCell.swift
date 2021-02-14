//
//  FutureForecastView.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-12.
//

import SwiftUI
import Weather

struct UpcomingWeatherCell: View {
    var forecast: Forecast
    @State private var isShowingDetailView: Bool = false
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(forecast.time)
                        .font(.headline)
                    Spacer()
                    Image(systemName: forecast.symbolName)
                        .font(.title)
                    Text(forecast.value(for: .t) + "°")
                        .font(.title2)
                    Image(systemName: "chevron.right")
                }
                .overlay(NavigationLink(
                    destination:  WeatherDetail(forecast: forecast),
                    isActive: $isShowingDetailView,
                    label: { EmptyView() }
                ).hidden())
            }
            .padding(8)
        }
        .onTapGesture {
            isShowingDetailView = true
        }
    }
}

#if DEBUG
struct UpcomingWeatherCell_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingWeatherCell(forecast: .example)
    }
}
#endif
