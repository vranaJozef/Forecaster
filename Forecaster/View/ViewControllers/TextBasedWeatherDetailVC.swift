//
//  TextBasedWeatherDetailVC.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 02/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import UIKit
import Disk

class TextBasedWeatherDetailVC: UIViewController {
    
    var weatherObject: WeatherObject?
    var searchedHistory: [String:String]?
    let cellID = "textBasedCurrentWeatherCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()                
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchWeatherInfo" {
            let vc = segue.destination as! WeatherInfoContainerVC
            if let wo = self.weatherObject {
                vc.weatherObject = wo
                vc.pushedFrom = String(describing: type(of: self))
            }
        }
    }
}
