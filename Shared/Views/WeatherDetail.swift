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
        .t,
        .pcat
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                LazyVGrid(columns: columns) {
                    ForEach(parameters) { parameter in
                        ParameterCell(parameter: forecast.get(parameter))
                    }
                }
            }.padding()
        }
        .navigationTitle(forecast.date)
    }
}

struct ParameterCell: View {
    var parameter: Parameter
    
    var body: some View {
        GroupBox {
            HStack {
                VStack(alignment: .leading) {
                    Text(parameter.name.rawValue)
                        .font(.headline)
                    Spacer()
                        .frame(height: 5)
                    switch parameter.presentation {
                    case .symbol(let name):
                        Image(systemName: name)
                            .font(.title3)
                    case .unit(let unit, let value):
                        Text("\(value) \(unit)")
                            .font(.body)
                    case .scale(let value, let min, let max):
                        Text("\(value) – \(min)...\(max)")
                    default:
                        Text("\(parameter.value)")
                            .font(.body)
                    }
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
