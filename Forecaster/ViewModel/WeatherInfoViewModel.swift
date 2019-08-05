//
//  WeatherInfoViewModel.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 05/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import Foundation
import Disk

protocol ViewModelDelegate {
    func updateUI()
}

class WeatherInfoViewModel {
    
    var weatherObject: WeatherObject?
    var forecastCollectionView: String?
    var cityLabel: String?
    var temperatureLabel: String?
    var descriptionLabel: String?
    var searchedHistory: [String:WeatherObject]?
    var tableData = [String: String]()
    var delegate: ViewModelDelegate?
    var fiveDaysForecastTableData = [String: String]()
    var tabelTitles = [String]()
    var forecastList: [[String:String]]?
    var oneDayForecast: [ForecastListDetail]?
    var fiveDayForecast: [ForecastListDetail]?
    
    init(weatherObject: WeatherObject?) {
        self.weatherObject = weatherObject
    }
    
    func saveToSearched() {
        if let weatherObject = self.weatherObject {
            if let name = weatherObject.currentWeather?.name {
                do {
                    self.searchedHistory = try Disk.retrieve("SearchedCities", from: .caches, as: [String:WeatherObject].self)
                    if var searchedHistory = self.searchedHistory {
                        if searchedHistory.count < 20 {
                            searchedHistory[name] = weatherObject
                            try Disk.save(searchedHistory, to: .caches, as: "SearchedCities")
                        }
                    } else {
                        self.searchedHistory = [String:WeatherObject]()
                        self.searchedHistory?[name] = weatherObject
                        try Disk.save(self.searchedHistory, to: .caches, as: "SearchedCities")
                    }
                } catch {
                    do {
                        self.searchedHistory = [String:WeatherObject]()
                        if var searchHistory = self.searchedHistory {
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
    }
    
    func update() {
        self.handleForecast()
        self.handleCurrentWeather()
        self.saveToSearched()
        self.delegate?.updateUI()
    }
    
    func dictForWeather() {
        if let currentWeather = self.weatherObject?.currentWeather {
            tableData["Description"] = currentWeather.weather?[0].description
            tableData["Sunrise"] = currentWeather.sys?.sunrise?.toUTC()
            tableData["Sunset"] = currentWeather.sys?.sunset?.toUTC()
            tableData["Humidity"] = currentWeather.main?.humidity?.toString().percent()
            tableData["Wind"] = currentWeather.wind?.speed?.toString().windSpeed()
        }
        tabelTitles = Array(tableData.keys).sorted()
    }
    
    func handleCurrentWeather() {
        if let currentWeather = self.weatherObject?.currentWeather {
            self.temperatureLabel = currentWeather.main?.temperature?.toString().celcius()
            self.descriptionLabel = currentWeather.weather?[0].main
            self.cityLabel = currentWeather.name
        }
        self.dictForWeather()
    }
    
    func handleForecast() {
        if let forecast = self.weatherObject?.forecast, let forecastList = forecast.list {
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
            self.fiveDayForecast = filteredArr
        }
    }
}
