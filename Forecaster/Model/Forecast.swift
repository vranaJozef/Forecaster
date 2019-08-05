//
//  Forecast.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 01/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import Foundation

struct Forecast: Codable {
    
    var list: [ForecastListDetail]?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(list, forKey: .list)
    }
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

struct ForecastListDetail: Codable {
    
    var dataTime: Int?
    var forecastMain: ForecastMainWeather?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dataTime, forKey: .dataTime)
        try container.encode(forecastMain, forKey: .forecastMain)
    }
    
    enum CodingKeys: String, CodingKey {
        case dataTime = "dt"
        case forecastMain = "main"
    }
}

struct ForecastMainWeather: Codable {
    
    var temperature: Double?    
    var minTemperature: Double?
    var maxTemperature: Double?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(temperature, forKey: .temperature)
        try container.encode(minTemperature, forKey: .minTemperature)
        try container.encode(maxTemperature, forKey: .maxTemperature)
    }
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
    }
}
