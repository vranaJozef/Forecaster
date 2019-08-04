//
//  WeatherResultVC.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 02/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import UIKit

class MapBasedWeatherResultVC: UIViewController {
    
    var currentWeather: CurrentWeather?
    var forecast: Forecast?
    @IBOutlet weak var locationImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateGoogleStaticMapsImage()
    }
    
    func updateGoogleStaticMapsImage() {
        var mapUrl = ""
        if let lat = self.currentWeather?.coordinates?.latitude, let lon = self.currentWeather?.coordinates?.lonngtitude {
            let staticMapUrl: String = "https://maps.google.com/maps/api/staticmap?markers=\(lat),\(lon)&\("zoom=15&size=\(2 * Int(locationImage.frame.size.width))x\(2 * Int(locationImage.frame.size.height))")&sensor=true&key=AIzaSyAsaqeR3rfYNXW8qFESu9DyiLmt85rsue8"            
            mapUrl = URL(string: staticMapUrl)?.absoluteString ?? ""
        }
        self.locationImage.imageFromServerURL(mapUrl, placeHolder: UIImage(named: "palceholder"))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapWeatherInfo" {
            let detailVC = segue.destination as! WeatherInfoContainerVC
            detailVC.currentWeather = currentWeather
            detailVC.forecast = forecast
        }
    }
}
