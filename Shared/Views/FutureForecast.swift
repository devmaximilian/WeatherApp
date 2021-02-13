//
//  FutureForecastView.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-12.
//

import SwiftUI
import Weather

struct FutureForecast: View {
    var forecast: Forecast
    @State private var isShowingDetailView: Bool = false
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("\(forecast.time)")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "cloud")
                        .font(.title)
                    Text(forecast.value(for: .t) + "°")
                        .font(.title2)
                    Image(systemName: "chevron.right")
                }
                .overlay(NavigationLink(
                    destination:  ForecastDetail(forecast: forecast),
                    isActive: $isShowingDetailView,
                    label: { EmptyView() }
                ).hidden())
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
        }
        .onTapGesture {
            isShowingDetailView = true
        }
    }
}

#if DEBUG
struct FutureForecast_Previews: PreviewProvider {
    static var previews: some View {
        FutureForecast(forecast: .example)
    }
}
#endif
