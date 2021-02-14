//
//  FutureForecastView.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-12.
//

import SwiftUI
import Weather

#if os(watchOS)
typealias GroupBox = Group
#endif

struct UpcomingWeatherCell: View {
    var forecast: Forecast
    @State private var isShowingDetailView: Bool = false
    
    var scale: CGFloat = {
        #if os(watchOS)
        return 0.8
        #else
        return 1.0
        #endif
    }()
    var padding: CGFloat = {
        #if os(watchOS)
        return 0
        #else
        return 8
        #endif
    }()
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(forecast.date)
                        .font(.headline)
                    Spacer()
                    #if !os(watchOS)
                    Image(systemName: forecast.symbolName)
                        .font(.title)
                        .scaleEffect(scale)
                    #endif
                    Text(forecast.value(for: .t) + "°")
                        .font(.title2)
                        .scaleEffect(scale)
                    Image(systemName: "chevron.right")
                }
                .overlay(NavigationLink(
                    destination:  WeatherDetail(forecast: forecast),
                    isActive: $isShowingDetailView,
                    label: { EmptyView() }
                ).hidden())
            }
            .padding(padding)
        }
        .scaleEffect(scale)
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
