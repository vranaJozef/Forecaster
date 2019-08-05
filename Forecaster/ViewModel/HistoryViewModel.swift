//
//  HistoryViewModel.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 05/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import Foundation
import Disk

protocol HistoryViewModelDelegate {
    func updateUI()
}

class HistoryViewModel {
    
    var searchHistory: [String:WeatherObject]?
    var weather: WeatherObject?
    var cities: [String]?
    var countries: [String]?
    var filteredCities: [String]?
    var delegate: HistoryViewModelDelegate?
    var filteredHistory: [String:String]?
    var buttonEnabled = true
    
    init(searchedHistory: [String:WeatherObject]?) {
        self.searchHistory = searchedHistory
    }
        
    func update(searchedText: String?) {
        if let searchedText = searchedText, !searchedText.isEmpty {
            if let searchHistory = self.searchHistory {
                self.buttonEnabled = true
                self.filteredCities = [String]()
                for (city, _) in searchHistory {
                    self.filteredCities?.append(city)
                }
                
                if let cities = self.filteredCities {
                    self.filteredCities = searchedText.isEmpty ? cities : cities.filter { $0.contains(searchedText) }
                    
                    if let filteredCities = self.filteredCities {
                        self.filteredHistory = [String:String]()
                        for filteredName in filteredCities {
                            if let country = searchHistory[filteredName] {
                                self.filteredHistory![filteredName] = country.currentWeather?.sys?.country
                            } else {
                                self.filteredHistory![filteredName] = ""
                            }
                        }
                    }
                    self.updateTableView()
                }
            }
        } else {
            self.filteredHistory = nil
            self.updateTableView()
            self.delegate?.updateUI()
        }
    }
    
    func updateTableView() {
        if let filtered = self.filteredHistory {
            self.cities?.removeAll()
            self.countries?.removeAll()
            for (city, country) in filtered {
                cities?.append(city)
                countries?.append(country)
            }
        } else {
            if let searchHistory = self.searchHistory {
                self.cities = [String]()
                self.countries = [String]()
                for (city, country) in searchHistory {
                    cities?.append(city)
                    if let country = country.currentWeather?.sys?.country {
                        countries?.append(country)
                    }
                }
            }
        }
        self.delegate?.updateUI()
    }
    
    func delete() {
        do {
            try Disk.clear(.caches)
            self.cities = nil
            self.countries = nil
            self.searchHistory = nil
            self.buttonEnabled = false
            self.delegate?.updateUI()
        } catch {
            print(error)
        }
    }
}
