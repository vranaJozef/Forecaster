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
    func updateWeatherObject(_ weatherObject: WeatherObject)
}

class LocationVC: UIViewController, CurrentLocationViewModelDelegate {
    
    let locationManager = CLLocationManager()
    var weatherObject: WeatherObject?           
    var delegate: LocationDelegate?    
    var viewModel: CurrentLocationViewModel?
    
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
        
        self.fetchWeather()
    }
    
    // MARK: - Private
    
    func fetchWeather(){
        guard let location = self.locationManager.location else { return }
        self.viewModel = CurrentLocationViewModel(location: location.coordinate)
        self.viewModel?.delegate = self
        self.viewModel?.fetchWeather()
    }
    
    // MARK: - CurrentLocationViewModelDelegate
    
    func updateWeatherObject(_ weatherObject: WeatherObject) {
        self.delegate?.updateWeatherObject(weatherObject)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "currentLocationWeatherInfo" {
            let vc = segue.destination as! WeatherInfoContainerVC
            vc.weatherObject = self.weatherObject
            self.delegate = vc
        }
    }
}


extension LocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    }
}
