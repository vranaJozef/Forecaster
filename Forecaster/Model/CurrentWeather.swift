//
//  Forecast.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 01/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import Foundation

struct CurrentWeather: Codable {
    
    var coordinates: CoordinatesItem?
    var weather: [Weather]?
    var main: CurrentWeatherDetail?
    var wind: Wind?
    var sys: Sys?
    var name: String?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinates, forKey: .coordinates)
        try container.encode(weather, forKey: .weather)
        try container.encode(main, forKey: .main)
        try container.encode(wind, forKey: .wind)
        try container.encode(sys, forKey: .sys)
        try container.encode(name, forKey: .name)
    }
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weather = "weather"
        case main = "main"
        case wind = "wind"
        case sys = "sys"
        case name = "name"
    }
}

struct CoordinatesItem: Codable {
    var lonngtitude: Double
    var latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case lonngtitude = "lon"
        case latitude = "lat"
    }
}

struct Weather: Codable {
    
    var main: String?
    var description: String?
        
    enum CodingKeys: String, CodingKey {
        case main = "main"
        case description = "description"
    }
}

struct CurrentWeatherDetail: Codable {
    
    var temperature: Double?
    var humidity: Int?    
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity = "humidity"        
    }
}

struct Wind: Codable {
    
    var speed: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
    }
}

struct Sys: Codable {
    
    var country: String?
    var sunrise: Int?
    var sunset: Int?
    
    enum CodingKeys: String, CodingKey {
        case country = "country"
        case sunrise = "sunrise"
        case sunset = "sunset"
    }
}
