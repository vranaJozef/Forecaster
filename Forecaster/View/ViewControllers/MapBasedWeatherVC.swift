//
//  MapBasedWeather.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 02/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import UIKit
import MapKit

class MapBasedWeatherVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var mapPin: MapPin?
    var currentWeather: CurrentWeather?
    var forecast: Forecast?
    var weatherObject: WeatherObject?
    let wm = WeatherManager()
    var locationManager = CLLocationManager()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 0.4
        self.mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.reset()
    }
    
    // MARK: - Actions
    
    @objc func handleLongPress(_ gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state != .began { return }
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        if let mapPin = self.mapPin, mapPin.coordinate.latitude != touchMapCoordinate.latitude, mapPin.coordinate.longitude != touchMapCoordinate.longitude {
            self.mapView.removeAnnotation(mapPin)
            mapPin.coordinate = touchMapCoordinate
            self.mapView.addAnnotation(mapPin)
        }
        if self.mapPin == nil {
            self.mapPin = MapPin(coordinate: touchMapCoordinate, title: "", subtitle: "")
            if let mapPin = self.mapPin {
                self.mapView.addAnnotation(mapPin)
            }
        }
        
        self.fetchWeather(coordinates: touchMapCoordinate)
    }
    
    func fetchWeather(coordinates: CLLocationCoordinate2D){
        let dispatchGroup = DispatchGroup()
        let queueImage = DispatchQueue(label: "com.currentWeather")
        let queueVideo = DispatchQueue(label: "com.forecast")
        
        dispatchGroup.enter()
        queueImage.async(group: dispatchGroup) {
            self.wm.getFiveDaysForecastByCoordinates(coordinates) { (forecast, error) in
                if let forecast = forecast {
                    self.forecast = forecast
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.enter()
        queueVideo.async(group: dispatchGroup) {
            self.wm.getWeatherByCoordinates(coordinates) { (weather, error) in
                if let weather = weather {
                    self.currentWeather = weather
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if let weather = self.currentWeather, let forecast = self.forecast {
                let wo = WeatherObject(weather: weather, forecast: forecast)
                self.weatherObject = wo
            }
        }
    }
    
    // MARK: - Private
    
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func reset() {
        self.currentWeather = nil
        self.forecast = nil
        self.weatherObject = nil
        self.mapPin = nil
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "currentWeather") {
            let vc = segue.destination as! MapBasedWeatherResultVC
            if let wo = self.weatherObject {
                vc.weatherObject = wo
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (self.currentWeather == nil) {
            let ac = UIAlertController.init(title: "Missing location", message: "Drop the pin on map, please", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { ( action ) in
                ac.dismiss(animated: true, completion: nil)
            }))
            self.present(ac, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
}

extension MapBasedWeatherVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.centerMapOnUserLocation()
    }
}
