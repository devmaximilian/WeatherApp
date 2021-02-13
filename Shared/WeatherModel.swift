//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-07.
//

import Foundation
import Combine
import Weather
import CoreLocation

final class WeatherModel: ObservableObject {
    private var cancellables: [String: AnyCancellable] = [:]
    private var weather: Weather? {
        didSet {
            guard let weather = weather else {
                return
            }
            self.forecast = weather.unsafeForecast
            self.upcoming = weather.forecasts.filter { $0.validTime != self.forecast?.validTime }
        }
    }
    @Published var loading: Bool = true
    @Published var forecast: Forecast?
    @Published var upcoming: [Forecast] = []
    @Published var placemark: CLPlacemark? = nil
    
    init() {}
    
    private func getLocation() -> AnyPublisher<(latitude: Double, longitude: Double), Error> {
        return Just((latitude: 59.3258414, longitude: 17.7018733))
            .tryMap { $0 }
            .eraseToAnyPublisher()
    }
    
    func update() {
        self.cancellables["weather"] = getLocation()
            .flatMap { coordinate in
                return Weather.publisher(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                // TODO: Add proper error handling
            }, receiveValue: { [weak self] weather in
                guard let self = self else { return }
                self.weather = weather
                self.loading = false
            })
        self.cancellables["location"] = getLocation()
            .flatMap { coordinate in
                return Future<CLPlacemark, Error> { completion in
                    let geocoder = CLGeocoder()
                    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                        guard let placemark = placemarks?.first else {
                            return completion(.failure(URLError(.unknown)))
                        }
                        completion(.success(placemark))
                    }
                }
            }
            .sink(receiveCompletion: { _ in
                // TODO: Add proper error handling
            }, receiveValue: { [weak self] placemark in
                guard let self = self else { return }
                
                self.placemark = placemark
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
