//
//  CurrentLocationViewModel.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 05/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import Foundation
import CoreLocation

protocol CurrentLocationViewModelDelegate {
    func updateWeatherObject(_ weatherObject: WeatherObject)
}

class CurrentLocationViewModel {
    
    let wm = WeatherManager()
    var location: CLLocationCoordinate2D?
    var currentWeather: CurrentWeather?
    var forecast: Forecast?
    var delegate: CurrentLocationViewModelDelegate?
    
    init(location: CLLocationCoordinate2D) {
        self.location = location
    }
    
    func fetchWeather() {
        if let location = self.location {
            let dispatchGroup = DispatchGroup()
            let queueImage = DispatchQueue(label: "com.currentWeather")
            let queueVideo = DispatchQueue(label: "com.forecast")
            
            dispatchGroup.enter()
            queueImage.async(group: dispatchGroup) {
                self.wm.getFiveDaysForecastByCoordinates(location) { (forecast, error) in
                    if let forecast = forecast {
                        self.forecast = forecast
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.enter()
            queueVideo.async(group: dispatchGroup) {
                self.wm.getWeatherByCoordinates(location) { (weather, error) in
                    if let weather = weather {
                        self.currentWeather = weather
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                if let weather = self.currentWeather, let forecast = self.forecast {
                    let wo = WeatherObject(weather: weather, forecast: forecast)
                    self.delegate?.updateWeatherObject(wo)
                }
            }
        }
    }
}
