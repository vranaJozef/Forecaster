//
//  LocationVC.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 02/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationDelegate {
    func updateWeather(_ weather: CurrentWeather)
    func updateForecast(_ forecast: Forecast)
}

class LocationVC: UIViewController {
    
    let locationManager = CLLocationManager()
    let wm = WeatherManager()
    var tableData = [String: String]()
    var tabelTitles = [String]()
    var currentWeather: CurrentWeather?
    var forecast: Forecast?
    var delegate: LocationDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.downloadDetails()
    }
    
    func downloadDetails(){
        guard let location = self.locationManager.location else { return }
        wm.getFiveDaysForecastByCoordinates(location.coordinate) { (forecast, error) in
            if let forecast = forecast {
                self.forecast = forecast
                if let fiveDayForecast = self.forecast {
                    self.delegate?.updateForecast(fiveDayForecast)
                }
            }
            self.wm.getWeatherByCoordinates(location.coordinate) { (weather, error) in
                if let weather = weather {
                    self.delegate?.updateWeather(weather)
                }
            }
        }                       
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "currentLocationWeatherInfo" {
            let vc = segue.destination as! WeatherInfoContainerVC
            vc.currentWeather = self.currentWeather
            vc.forecast = self.forecast
            self.delegate = vc
        }
    }
}


extension LocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    }
}
