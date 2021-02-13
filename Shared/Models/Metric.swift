//
//  Metric.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-09.
//

import Foundation
import struct Weather.Parameter

fileprivate let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.alwaysShowsDecimalSeparator = false
    formatter.currencyDecimalSeparator = Locale.current.decimalSeparator
    formatter.groupingSeparator = Locale.current.groupingSeparator
    formatter.numberStyle = .decimal
    formatter.generatesDecimalNumbers = true
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 1
    formatter.usesGroupingSeparator = true
    formatter.maximumSignificantDigits = 4
    formatter.roundingMode = .halfDown
    return formatter
}()

struct Metric: Identifiable {
    var id: String {
        return self.name
    }
    
    let name: String
    let value: Double
    let unit: String
    let systemName: String
    
    init(name: String, value: Double, unit: String, systemName: String) {
        self.name = name
        self.value = value
        self.unit = unit
        self.systemName = systemName
    }
    
    var displayValue: String {
        numberFormatter.string(from: NSNumber(value: value)) ?? ""
    }
}

extension Metric {
    static var preview: Metric {
        Metric(name: "Wind speed", value: 3.5, unit: "m/s", systemName: "wind")
    }
}

// MARK: Parameter-related extensions

extension Parameter {
    var metric: Metric {
        return Metric(
            name: self.displayName,
            value: self.values.first ?? 0,
            unit: self.unit,
            systemName: self.systemName
        )
    }
    
    fileprivate var displayName: String {
        return self.name.rawValue
    }
    
    fileprivate var systemName: String {
        switch name {
        case .ws: return "wind"
        case .hcc_mean: return "cloud.fill"
        case .pmin, .pmax, .pmedian, .pmean: return "cloud.rain.fill"
        case .spp: return "cloud.snow.fill"
        case .t: return "thermometer"
        default: return ""
        }
    }
}
