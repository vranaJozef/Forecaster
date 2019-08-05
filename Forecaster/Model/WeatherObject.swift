//
//  WeatherObject.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 05/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import Foundation

struct WeatherObject: Codable {
    
    var currentWeather: CurrentWeather?
    var forecast: Forecast?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentWeather, forKey: .currentWeather)
        try container.encode(forecast, forKey: .forecast)
    }
    
    init(weather: CurrentWeather, forecast: Forecast) {
        self.currentWeather = weather
        self.forecast = forecast
    }
}
