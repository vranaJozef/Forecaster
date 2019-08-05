//
//  SPFlightManager.swift
//  SPFlight
//
//  Created by Jozef Vrana on 11/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// Struct wrapper for ability to store NSCache

//class StructWrapper: NSObject {
//
//    let value: Forecast
//
//    init(_ value: Forecast) {
//        self.value = value
//    }
//
//    override func isEqual(_ object: Any?) -> Bool {
//        guard let other = object as? Forecast else {
//            return false
//        }
//        return value.id == other.id
//    }
//}

class WeatherManager {
        
    let client = Client.init(baseUrl: "https://api.openweathermap.org/data/2.5")
    var flightTask: URLSessionTask?
    let flightsCache = NSCache<NSString, AnyObject>()
    let dateFromCache = NSCache<NSString, NSString>()
    var temporaryFlights = [CurrentWeather]()
    
    func getCurrentWeatherForCity(_ city: String, completion: @escaping ((_ weather:CurrentWeather?, _ error: WebError<APIError>?) -> Void)) {
        self.flightTask?.cancel()
        let resource = RequestBuilder.getCurrentWeatherForCity(city)
        self.flightTask = client.load(resource: resource) {[weak self] response in
            if let currentWeather = response.value {
                completion(currentWeather, nil)
                } else if let error = response.error {
                completion(nil, error)
            }
        }
    }
    
    func getFiveDaysForecastForCity(_ city: String, completion: @escaping ((_ forecast: Forecast?, _ error: WebError<APIError>?) -> Void)) {
        self.flightTask?.cancel()
        let resource = RequestBuilder.getFiveDaysForecastForCity(city)
        self.flightTask = client.load(resource: resource) {[weak self] response in
            if let forecast = response.value {
                completion(forecast, nil)
            } else if let error = response.error {
                completion(nil, error)
            }
        }
    }
    
    func getWeatherByCoordinates(_ coordinates: CLLocationCoordinate2D, completion: @escaping ((_ weather: CurrentWeather?, _ error: WebError<APIError>?) -> Void)) {
        self.flightTask?.cancel()
        let resource = RequestBuilder.getCurrentWeatherByCoordinates(coordinates)
        self.flightTask = client.load(resource: resource) {[weak self] response in
            if let currentWeather = response.value {
                completion(currentWeather, nil)
            } else if let error = response.error {
                completion(nil, error)
            }
        }
    }
    
    func getFiveDaysForecastByCoordinates(_ coordinates: CLLocationCoordinate2D, completion: @escaping ((_ weather: Forecast?, _ error: WebError<APIError>?) -> Void)) {
        self.flightTask?.cancel()
        let resource = RequestBuilder.getFiveDaysForecastByCoordinates(coordinates)
        self.flightTask = client.load(resource: resource) {[weak self] response in
            if let forecast = response.value {
                completion(forecast, nil)
            } else if let error = response.error {
                completion(nil, error)
            }
        }
    }       
}
