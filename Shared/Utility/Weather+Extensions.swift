//
//  Weather+Extensions.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-12.
//

import Foundation
import Weather

fileprivate let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.alwaysShowsDecimalSeparator = false
    formatter.currencyDecimalSeparator = Locale.current.decimalSeparator
    formatter.groupingSeparator = Locale.current.groupingSeparator
    formatter.generatesDecimalNumbers = true
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2
    formatter.usesGroupingSeparator = true
    formatter.maximumSignificantDigits = 1
    formatter.usesSignificantDigits = true
    formatter.minimumSignificantDigits = 0
    formatter.roundingMode = .halfDown
    return formatter
}()

fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH"
    return formatter
}()

fileprivate let relativeDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .medium
    formatter.doesRelativeDateFormatting = true
    formatter.locale = .current
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()

extension DateFormatter {
    fileprivate func string(from date: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

extension Forecast {
    public func value(for name: Parameter.Name) -> String {
        let number = NSNumber(value: self.get(name).value)
        return numberFormatter.string(from: number) ?? "-/-"
    }
    public var time: String {
        return dateFormatter.string(from: validTime, format: "HH")
    }
    public var date: String {
        return relativeDateFormatter.string(from: validTime)
            .replacingOccurrences(of: ":00", with: "")
    }
    public var day: String {
        return dateFormatter.string(from: validTime, format: "dd")
    }
    // TODO: Refactor symbol resolution
    public var symbolName: String {
        var name = ""
        let time = Int(self.time) ?? 0
        switch Int(get(.wsymb2, \.value)) {
            case 1: name = time <= 17 && time >= 8 ? "sun.max.fill" : "moon.stars.fill"
            case 2: name = time <= 17 && time >= 8 ? "sun.max" : "moon"
            case 3: name = "cloud"
            case 4: name = time <= 17 && time >= 8 ? "cloud.sun" : "cloud.moon"
            case 5: name = "cloud.fill"
            case 6: name = time <= 17 && time >= 8 ? "cloud.sun.fill" : "cloud.moon.fill"
            case 7: name = "cloud.fog.fill"
            case 11: name = "cloud.bolt.rain.fill"
            case 8, 18: name = "cloud.drizzle.fill"
            case 9, 19: name = "cloud.rain.fill"
            case 10, 20: name = "cloud.heavyrain.fill"
            case 21: name = "cloud.bolt"
            case 12, 13, 22, 23: name = "cloud.sleet"
            case 14, 24: name = "cloud.sleet.fill"
            case 15, 16, 25, 26: name = "cloud.snow"
            case 17, 27: name = "cloud.snow.fill"
            default: name = "sparkles"
        }
        return name
    }
}

extension Forecast: Identifiable {
    public var id: String {
        return validTime.description
    }
}

extension Parameter.Name: Identifiable {
    public var id: String {
        return rawValue
    }
}
