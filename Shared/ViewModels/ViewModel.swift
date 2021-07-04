//
//  ViewModel.swift
//  WeatherApp (iOS)
//
//  Created by Maximilian Wendel on 2021-07-04.
//

import Foundation

class ViewModel: ObservableObject {

    // MARK: - State

    enum State {
        case loading
        case loaded(Weather)
        case error(Error)
    }
    
    // MARK: - Issue
    
    enum Issue: Error {
        case unknownLocation
        case general
    }

    // MARK: - Properties

    /// State directly observable by views.
    @Published private(set) var state: State

    // service

    // MARK: - Init

    /// Initializer to provide a default state.
    init(state: State = .loading) {
        self.state = state
    }

    // MARK: - API

    /// Fetches a weather forecast if possible.
    func initialize(completionHandler: ((Result<Void, Error>) -> Void)? = nil) {
        // Perform initialization
        completionHandler?(.success(()))
    }

    /// Fetches a new weather forecast.
    func refresh() {
        state = .loading

        // Perform refresh
    }

    // Public methods...

    // MARK: - Private

    // Private methods...
    
}
