//
//  RequestBuilder.swift
//  SPFlight
//
//  Created by Jozef Vrana on 10/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation
import CoreLocation

class RequestBuilder {
        
    class func getCurrentWeatherForCity(_ city: String) -> Resource<CurrentWeather, APIError> {
        var resource = Resource<CurrentWeather, APIError>(jsonDecoder: JSONDecoder(), path: "weather")
        resource.method = .get
        let queryItems = ["q":city,
                          "appid": "acd438da4eaef39bf3321a50de4f6ac3",
                          "units": "metric"]
        resource.queryItems = queryItems
        return resource
    }
    
    class func getFiveDaysForecastForCity(_ city: String) -> Resource<Forecast, APIError> {
        var resource = Resource<Forecast, APIError>(jsonDecoder: JSONDecoder(), path: "forecast")
        resource.method = .get
        let queryItems = ["q":city,
                          "appid": "acd438da4eaef39bf3321a50de4f6ac3",
                          "units": "metric"]
        resource.queryItems = queryItems
        return resource
    }
    
    class func getCurrentWeatherByCoordinates(_ coordinates: CLLocationCoordinate2D) -> Resource<CurrentWeather, APIError> {
        var resource = Resource<CurrentWeather, APIError>(jsonDecoder: JSONDecoder(), path: "weather")
        resource.method = .get
        let queryItems = ["lat":String(coordinates.latitude),
                          "lon":String(coordinates.longitude),
                          "appid": "acd438da4eaef39bf3321a50de4f6ac3",
                          "units": "metric"]
        resource.queryItems = queryItems
        return resource
    }
    
    class func getFiveDaysForecastByCoordinates(_ coordinates: CLLocationCoordinate2D) -> Resource<Forecast, APIError> {
        var resource = Resource<Forecast, APIError>(jsonDecoder: JSONDecoder(), path: "forecast")
        resource.method = .get
        let queryItems = ["lat":String(coordinates.latitude),
                          "lon":String(coordinates.longitude),
                          "appid": "acd438da4eaef39bf3321a50de4f6ac3",
                          "units": "metric"] 
        resource.queryItems = queryItems
        return resource
    }
}
