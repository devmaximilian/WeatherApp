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
    private let locationManager: LocationManager = .init()
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
    
    // MARK: Published
    
    @Published var loading: Bool = true
    @Published var forecast: Forecast?
    @Published var upcoming: [Forecast] = []
    @Published var placemark: CLPlacemark? = nil
    @Published var shouldRequestAuthorization = false
    
    init() {
        self.configure()
    }
    
    private func configure() {
        self.cancellables["authorization-status"] = locationManager.authorizationStatus
            .sink(receiveCompletion: { [weak self] completion in
                // TODO: Add proper error handling
            }, receiveValue: { [weak self] authorizationStatus in
                guard let self = self else { return }
                switch authorizationStatus {
                case .notDetermined:
                    self.shouldRequestAuthorization = true
                default:
                    self.requestAuthorization()
                }
            })
        self.cancellables["weather"] = locationManager.location
            .flatMap { location in
                return Weather.publisher(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                print(completion)
                // TODO: Add proper error handling
            }, receiveValue: { [weak self] weather in
                guard let self = self else { return }
                self.weather = weather
                self.loading = false
            })
        self.cancellables["location"] = locationManager.placemark
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                // TODO: Add proper error handling
            }, receiveValue: { [weak self] placemark in
                guard let self = self else { return }
                self.placemark = placemark
            })
    }
    
    func requestAuthorization() {
        self.locationManager.requestAuthorization()
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

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager
    private var cancellables: [String: AnyCancellable] = [:]
    
    let location: PassthroughSubject<CLLocation, Error> = .init()
    let authorizationStatus: PassthroughSubject<CLAuthorizationStatus, Error> = .init()
    let placemark: PassthroughSubject<CLPlacemark, Error> = .init()
    
    public override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.configure()
    }
    
    private func configure() {
        // Configure placemark subscription
        self.cancellables["placemark"] = self.location
            .flatMap { location in
                return Future<CLPlacemark, Error> { completion in
                    let geocoder = CLGeocoder()
                    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                        guard let placemark = placemarks?.first else {
                            return completion(.failure(URLError(.unknown)))
                        }
                        completion(.success(placemark))
                    }
                }
            }.sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.placemark.send(completion: completion)
            }, receiveValue: { [weak self] placemark in
                guard let self = self else { return }
                self.placemark.send(placemark)
            })
        
        // Send initial values
        self.authorizationStatus.send(locationManager.authorizationStatus)
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus.send(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location.send(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.location.send(completion: .failure(error))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateTo newLocation: CLLocation, from oldLocation: CLLocation) {
        self.location.send(newLocation)
    }
}
