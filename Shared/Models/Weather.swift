//
//  Weather.swift
//  WeatherApp (iOS)
//
//  Created by Maximilian Wendel on 2021-07-04.
//

import Foundation

struct Weather {
    
    // MARK: - Condition
    
    enum Condition {
        case sunny
    }
    
    // MARK: - Properties
    
    let temperature: Int
    let condition: Condition
}
