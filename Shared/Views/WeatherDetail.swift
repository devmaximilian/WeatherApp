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
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150), spacing: nil, alignment: .leading),
        GridItem(.adaptive(minimum: 150), spacing: nil, alignment: .leading)
    ]
    var parameters: [Parameter.Name] = [
        .t, .msl, .vis, .ws, .wd, .r, .tstm, .tcc_mean, .lcc_mean, .mcc_mean, .hcc_mean, .gust, .pmin, .pmax, .pmean, .pmedian, .spp, .pcat
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 10) {
                
                LazyVGrid(columns: columns) {
                    ParameterSection(label: "Temperature") {
                        Text("\(forecast.get(.t, \.displayValue))°")
                    }
                    ParameterSection(label: "Relative humidity") {
                        Text("\(Int(forecast.get(.r, \.value)))%")
                    }
                    ParameterSection(label: "Wind") {
                        Text("\(forecast.get(.ws, \.displayValue)) \(forecast.get(.ws, \.displayUnit)) (\(forecast.get(.gust, \.displayValue)) \(forecast.get(.gust, \.displayUnit))), \(forecast.get(.wd).direction)")
                    }
                    ParameterSection(label: "Pressure") {
                        Text("\(Int(forecast.get(.msl, \.value))) \(forecast.get(.msl, \.displayUnit))")
                    }
                    ParameterSection(label: "Precipitation") {
                        HStack {
                            if forecast.get(.pmin, \.value) > 0 {
                                Image(systemName: forecast.get(.pcat).category)
                                    .font(.title3)
                                Text("\(forecast.get(.pmin, \.displayValue)) – \(forecast.get(.pmax, \.displayValue)) \(forecast.get(.pmean, \.displayUnit))")
                            } else {
                                Text("–")
                            }
                        }
                    }
                    ParameterSection(label: "Visibility") {
                        Text("\(forecast.get(.vis, \.displayValue)) \(forecast.get(.vis, \.displayUnit))")
                    }
                    ParameterSection(label: "Thunder probability") {
                        forecast.get(.tstm, \.value) > 0 ? Text("\(Int(forecast.get(.tstm, \.value)))%") : Text("–")
                    }
                    ParameterSection(label: "Cloud coverage") {
                        HStack {
                            if forecast.get(.lcc_mean, \.value) > 0 {
                                VStack(alignment: .leading) {
                                    Text("Low level")
                                        .font(.subheadline)
                                    Text("\(forecast.get(.lcc_mean, \.displayValue)) \(forecast.get(.lcc_mean, \.displayUnit))")
                                }
                                Spacer()
                            }
                            if forecast.get(.tcc_mean, \.value) > 0 {
                                VStack(alignment: .leading) {
                                    Text("Medium level")
                                        .font(.subheadline)
                                    Text("\(forecast.get(.mcc_mean, \.displayValue)) \(forecast.get(.mcc_mean, \.displayUnit))")
                                }
                                Spacer()
                            }
                            if forecast.get(.tcc_mean, \.value) > 0 {
                                VStack(alignment: .leading) {
                                    Text("High level")
                                        .font(.subheadline)
                                    Text("\(forecast.get(.hcc_mean, \.displayValue)) \(forecast.get(.hcc_mean, \.displayUnit))")
                                }
                            }
                        }
                    }
                }
            }.padding()
        }
        .navigationTitle(forecast.date)
    }
}

struct ParameterSection<Content>: View where Content: View {
    var label: String
    let viewBuilder: () -> Content
    
    var body: some View {
        GroupBox {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(label)
                        .font(.headline)
                    viewBuilder()
                    Spacer(minLength: 0)
                }
                Spacer()
            }
            .padding(10)
        }
    }
}

#if DEBUG
struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetail(forecast: .example)
    }
}
#endif
