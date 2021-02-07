//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-07.
//

import Foundation
import Combine
import Weather

final class WeatherModel: ObservableObject {
    private var cancellables: [String: AnyCancellable] = [:]
    private var weather: Weather? {
        didSet {
            guard let weather = weather else {
                return
            }
            temperature = Int(weather.get(\.values, for: .t).first ?? 0)
            symbol = String(weatherSymbol: Int(weather.get(\.values, for: .wsymb2).first ?? 0))
        }
    }
    
    @Published var temperature: Int = 0
    @Published var symbol: String = ""
    
    init() {}
    
    func update() {
        self.cancellables["weather"] = Weather.publisher(latitude: 59.3258414, longitude: 17.7018733)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] weather in
                guard let self = self else { return }
                self.weather = weather
            })
    }
}

extension String {
    init(weatherSymbol: Int) {
        switch weatherSymbol {
        case 3: self = "cloud"
        case 5: self = "cloud.fill"
        case 7: self = "cloud.fog.fill"
        case 11: self = "cloud.bolt.rain.fill"
        case 8, 18: self = "cloud.drizzle.fill"
        case 9, 19: self = "cloud.rain.fill"
        case 10, 20: self = "cloud.heavyrain.fill"
        case 21: self = "cloud.bolt"
        case 12, 13, 22, 23: self = "cloud.sleet"
        case 14, 24: self = "cloud.sleet.fill"
        case 15, 16, 25, 26: self = "cloud.snow"
        case 17, 27: self = "cloud.snow.fill"
        default: self = "sparkles"
        }
    }
}
