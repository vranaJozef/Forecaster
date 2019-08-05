//
//  WeatherInfoContainerVC.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 04/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Disk

class WeatherInfoContainerVC: UIViewController, LocationDelegate {
    
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    let tableViewCellID = "locationWeatherCellID"
    let forecastCellID = "locationForecastCellID"
    let collectionViewCellID = "forecastCollectionViewCellID"
    let wm = WeatherManager()
    var searchedHistory: [String:WeatherObject]?
    var currentWeather: CurrentWeather? {
        didSet {
            self.reloadTableView()
        }
    }
    var tableData = [String: String]()
    var fiveDaysForecastTableData = [String: String]()
    var tabelTitles = [String]()
    var forecast: Forecast? {
        didSet {
            self.reloadTableView()
        }
    }
    var forecastList: [[String:String]]?
    var oneDayForecast: [ForecastListDetail]?
    var fiveDayForecast: [ForecastListDetail]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.forecastTableView.register(UINib(nibName: "OneDayForecastTableViewCell", bundle: nil), forCellReuseIdentifier: forecastCellID)
        self.forecastTableView.register(UINib(nibName: "FiveDaysForecastTableViewCell", bundle: nil), forCellReuseIdentifier: tableViewCellID)
        self.forecastCollectionView.register(UINib(nibName: "CustomForecastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionViewCellID)
        self.update()
    }
    
    func update() {
        self.handleForecast()
        self.handleCurrentWeather()
        self.saveWeather()
        self.reloadTableView()                
    }
    
    func saveWeather() {
        if let currentWeather = self.currentWeather, let forecast = self.forecast {
            let weatherObject = WeatherObject(weather: currentWeather, forecast: forecast)
            do {
                self.searchedHistory = try Disk.retrieve("SearchedCities", from: .caches, as: [String:WeatherObject].self)
                if var searchedHistory = self.searchedHistory, let name = currentWeather.name {
                    if searchedHistory.count < 20 {
                        searchedHistory[name] = weatherObject
                        try Disk.save(searchedHistory, to: .caches, as: "SearchedCities")
                    }
                } else {
                    self.searchedHistory = [String:WeatherObject]()
                    self.searchedHistory?[currentWeather.name!]! = weatherObject
                    try Disk.save(self.searchedHistory, to: .caches, as: "SearchedCities")
                }
            } catch {
                do {
                    self.searchedHistory = [String:WeatherObject]()
                    if var searchHistory = self.searchedHistory, let name = currentWeather.name {
                        searchHistory[name] = weatherObject
                        self.searchedHistory = searchHistory
                        try Disk.save(self.searchedHistory, to: .caches, as: "SearchedCities")
                    }
                } catch {
                    print(error)
                }
                print(error)
            }
        }
    }
    
    func updateWeather(_ weather: CurrentWeather) {
        self.currentWeather = weather
        self.update()
    }
    
    func updateForecast(_ forecast: Forecast) {
        self.forecast = forecast
        self.update()
    }
    
    func dictForWeather() {
        if let currentWeather = self.currentWeather {
            tableData["Description"] = currentWeather.weather?[0].description
            tableData["Sunrise"] = currentWeather.sys?.sunrise?.toUTC()
            tableData["Sunset"] = currentWeather.sys?.sunset?.toUTC()
            tableData["Humidity"] = currentWeather.main?.humidity?.toString().percent()
            tableData["Wind"] = currentWeather.wind?.speed?.toString().windSpeed()
        }
        tabelTitles = Array(tableData.keys).sorted()
        
        self.reloadTableView()
    }
    
    func dictForForecast() {
        self.reloadTableView()
    }
    
    func handleCurrentWeather() {
        if let currentWeather = self.currentWeather {
            DispatchQueue.main.async {
                self.temperatureLabel.text = currentWeather.main?.temperature?.toString().celcius()
                self.descriptionLabel.text = currentWeather.weather?[0].main
                self.cityLabel.text = currentWeather.name
            }
        }
        self.dictForWeather()
    }
    
    func handleForecast() {
        if let forecast = self.forecast, let forecastList = forecast.list {
            self.oneDayForecast = [ForecastListDetail]()
            self.fiveDayForecast = [ForecastListDetail]()
            for forecasItem in forecastList {
                let desiredDate = Date(timeIntervalSince1970: Double(forecasItem.dataTime!))
                if let diff = Calendar.current.dateComponents([.hour], from: Date(), to: desiredDate).hour, diff < 24 {
                    oneDayForecast?.append(forecasItem)
                }
                if let diff = Calendar.current.dateComponents([.hour], from: Date(), to: desiredDate).hour, diff > 24 {
                    fiveDayForecast?.append(forecasItem)
                }
            }
        }
        
        let filteredArr = fiveDayForecast?.enumerated().compactMap { index, element in index % 8 != 7 ? nil : element }
        if let filteredArr = filteredArr {
            for item in filteredArr {
                print(Date(timeIntervalSince1970: Double(item.dataTime!)))
            }
            self.fiveDayForecast = filteredArr
            self.dictForForecast()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.forecastCollectionView.reloadData()
            self.forecastTableView.reloadData()
        }
    }
}

extension WeatherInfoContainerVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.forecastTableView {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.forecastTableView.frame.height * 0.5
        }
        if indexPath.row == 1 {
            return self.forecastTableView.frame.height * 0.5
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.forecastTableView {
            if indexPath.row == 0 {
                var cell:OneDayForecastTableViewCell? = self.forecastTableView.dequeueReusableCell(withIdentifier: forecastCellID) as? OneDayForecastTableViewCell
                if cell == nil {
                    cell = OneDayForecastTableViewCell(style: .default, reuseIdentifier: forecastCellID)
                }
                if let fiveDayForecast = self.fiveDayForecast {
                    cell?.forecastDetail = fiveDayForecast
                }
                return cell!
            }
            if indexPath.row == 1 {
                var cell:FiveDaysForecastTableViewCell? = self.forecastTableView.dequeueReusableCell(withIdentifier: tableViewCellID) as? FiveDaysForecastTableViewCell
                if cell == nil {
                    cell = FiveDaysForecastTableViewCell(style: .subtitle, reuseIdentifier: tableViewCellID)
                }
                if !tableData.isEmpty && !tabelTitles.isEmpty {
                    cell?.tableData = tableData
                    cell?.tableTitles = tabelTitles
                }
                
                return cell!
            }
            
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

extension WeatherInfoContainerVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let forecastList = self.oneDayForecast {
            return forecastList.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.forecastCollectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath) as! CustomForecastCollectionViewCell
        if let forecastList = self.oneDayForecast {
            cell.timeLabel?.text = indexPath.row == 0 ? "Now" : forecastList[indexPath.row].dataTime?.toUTC()
            cell.temperature?.text = forecastList[indexPath.row].forecastMain?.temperature?.toString().celcius()
        }
        
        return cell
    }
}
