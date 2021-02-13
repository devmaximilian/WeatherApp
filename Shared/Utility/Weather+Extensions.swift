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
        return date
    }
    public var date: String {
        return relativeDateFormatter.string(from: validTime)
            .replacingOccurrences(of: ":00", with: "")
    }
    public var day: String {
        return dateFormatter.string(from: validTime, format: "dd")
    }
    public var symbolName: String {
        return "cloud"
    }
}

extension Forecast: Identifiable {
    public var id: String {
        return validTime.description
    }
}
