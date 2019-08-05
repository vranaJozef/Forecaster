//
//  HistoryDetailVC.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 05/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import UIKit

class HistoryDetailVC: UIViewController  {
    
    var weatherObject: WeatherObject?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyWeatherInfo" {
            let detailVC = segue.destination as! WeatherInfoContainerVC
            if let weather = self.weatherObject {
                detailVC.weatherObject = weather
            }
        }
    }
}
