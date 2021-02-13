//
//  Preferences.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-13.
//

import Foundation
import SwiftUI

@propertyWrapper struct Preference<Value>: DynamicProperty {
    private let key: String
    private let defaultValue: Value
    private let storage: UserDefaults
    
    @State private var value: Value
    
    var wrappedValue: Value {
        get {
            value
        }
        nonmutating set {
            storage.setValue(newValue, forKey: key)
            value = newValue
        }
    }
    
    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    
    init(key: String, defaultValue: Value, storage: UserDefaults) {
        self.key = key
        self.storage = storage
        self.defaultValue = defaultValue
        self._value = State(wrappedValue: storage.value(forKey: key) as? Value ?? defaultValue)
    }
}

extension Preference where Value: ExpressibleByNilLiteral {
    init(key: String, storage: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, storage: storage)
    }
}

extension Bool: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = false
    }
}
