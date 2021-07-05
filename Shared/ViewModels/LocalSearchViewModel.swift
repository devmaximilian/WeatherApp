//
//  LocalSearchViewModel.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-07-05.
//

import Foundation
import Combine
import MapKit

class LocalSearchViewModel: ObservableObject {
    var queryCancellable: AnyCancellable?
    var resultsCancellable: AnyCancellable?

    // MARK: - State

    enum State {
        case waitingForInput
        case loading
        case loaded([MKLocalSearchCompletion])
        case error(Error)
    }

    // MARK: - Properties

    /// State directly observable by views.
    @Published private(set) var state: State
    
    /// Search query modifiable by input.
    @Published var searchQuery: String = ""

    private let localSearchCompleter: LocalSearchCompleter = .init()

    // MARK: - Init

    /// Initializer to provide a default state.
    init(state: State = .waitingForInput) {
        self.state = state
    }

    // MARK: - API

    func initialize(completionHandler: ((Result<Void, Error>) -> Void)? = nil) {
        // Perform initialization
        completionHandler?(.success(()))
        
        // Configure subscriptions
        queryCancellable = $searchQuery.debounce(for: 0.5, scheduler: RunLoop.main).sink(receiveValue: localSearchCompleter.search)
        resultsCancellable = localSearchCompleter.$results.sink() { [weak self] results in
            guard let self = self else { return }
            
            self.state = .loaded(results)
        }
    }

    func refresh() {
        state = .loading

        // Perform refresh
    }
}

fileprivate class LocalSearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    private lazy var searchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.pointOfInterestFilter = .excludingAll
        completer.delegate = self
        return completer
    }()
    
    var cancellable: AnyCancellable? = nil
    
    @Published var results: [MKLocalSearchCompletion] = []
    
    // MARK: - API
    
    func search(_ queryFragment: String) {
        searchCompleter.queryFragment = queryFragment
    }
    
    // MARK: Internal
    
    
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
    }
}

extension MKLocalSearchCompletion: Identifiable {
    public var id: Int {
        return hash
    }
}
