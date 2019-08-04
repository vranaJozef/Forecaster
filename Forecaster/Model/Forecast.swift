//
//  Forecast.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 01/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import Foundation

struct Forecast: Decodable {
    
    var list: [ForecastListDetail]?
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

struct ForecastListDetail: Decodable {
    
    var dataTime: Int?
    var forecastMain: ForecastMainWeather?
    
    enum CodingKeys: String, CodingKey {
        case dataTime = "dt"
        case forecastMain = "main"
    }
}

struct ForecastMainWeather: Decodable {
    
    var temperature: Double?    
    var minTemperature: Double?
    var maxTemperature: Double?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
    }
}
