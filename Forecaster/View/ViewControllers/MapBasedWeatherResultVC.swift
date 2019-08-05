//
//  WeatherResultVC.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 02/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import UIKit

class MapBasedWeatherResultVC: UIViewController {
    
    var weatherObject: WeatherObject?
    @IBOutlet weak var locationImage: UIImageView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateGoogleStaticMapsImage()
    }
        
    // MARK: - Update UI

    func updateGoogleStaticMapsImage() {
        var mapUrl = ""
        if let lat = self.weatherObject?.currentWeather?.coordinates?.latitude, let lon = self.weatherObject?.currentWeather?.coordinates?.lonngtitude {
            let staticMapUrl: String = "https://maps.google.com/maps/api/staticmap?markers=\(lat),\(lon)&\("zoom=15&size=\(2 * Int(locationImage.frame.size.width))x\(2 * Int(locationImage.frame.size.height))")&sensor=true&key=AIzaSyAsaqeR3rfYNXW8qFESu9DyiLmt85rsue8"            
            mapUrl = URL(string: staticMapUrl)?.absoluteString ?? ""
        }
        self.locationImage.imageFromServerURL(mapUrl, placeHolder: UIImage(named: "palceholder"))
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapWeatherInfo" {
            let detailVC = segue.destination as! WeatherInfoContainerVC
            if let weatherObject = self.weatherObject {
                detailVC.weatherObject = weatherObject
            }
        }
    }
}
