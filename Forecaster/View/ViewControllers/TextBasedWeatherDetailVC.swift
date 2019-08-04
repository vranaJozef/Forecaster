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
    
    var currentWeather: CurrentWeather?
    var forecast: Forecast?
    var searchedHistory: [String:String]?
    let cellID = "textBasedCurrentWeatherCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentWeather = self.currentWeather {
            do {
                self.searchedHistory = try Disk.retrieve("SearchedCities", from: .caches, as: [String:String].self)
                if var searchedHistory = self.searchedHistory {
                    searchedHistory[currentWeather.name!] = currentWeather.sys?.country!
                    try Disk.save(searchedHistory, to: .caches, as: "SearchedCities")
                } else {
                    self.searchedHistory = [String:String]()
                    self.searchedHistory![currentWeather.name!] = currentWeather.sys?.country!
                    try Disk.save(self.searchedHistory, to: .caches, as: "SearchedCities")
                }
            } catch {
                self.searchedHistory = [String:String]()
                self.searchedHistory![currentWeather.name!] = currentWeather.sys?.country!
                do {
                    try Disk.save(self.searchedHistory, to: .caches, as: "SearchedCities")
                } catch {
                    print(error.localizedDescription)
                }
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchWeatherInfo" {
            let vc = segue.destination as! WeatherInfoContainerVC
            vc.currentWeather = self.currentWeather
            vc.forecast = self.forecast
        }
    }
}
