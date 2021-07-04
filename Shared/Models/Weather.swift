//
//  Weather.swift
//  WeatherApp (iOS)
//
//  Created by Maximilian Wendel on 2021-07-04.
//

import Foundation

struct Weather: Identifiable {
    
    // MARK: - Condition
    
    enum Condition {
        case sunny
    }
    
    // MARK: - Properties
    
    let id: UUID = .init()
    let temperature: Int
    let condition: Condition
}

// MARK: Time

extension Weather {
    var timeString: String {
        return "Now"
    }
}

// MARK: Condition symbol

extension Weather {
    var conditionSymbol: String {
        return "cloud.drizzle.fill"
    }
}
