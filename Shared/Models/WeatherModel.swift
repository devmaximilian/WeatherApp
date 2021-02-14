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
    
    // TODO: Method to update relevant forecasts and set new current
    
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
                    self.shouldRequestAuthorization = false
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
        self.authorizationStatus.send(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.location.send(completion: .failure(error))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateTo newLocation: CLLocation, from oldLocation: CLLocation) {
        self.location.send(newLocation)
        self.authorizationStatus.send(manager.authorizationStatus)
    }
}
