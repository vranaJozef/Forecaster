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

class WeatherInfoContainerVC: UIViewController, LocationDelegate, ViewModelDelegate {
    
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var weatherObject: WeatherObject? {
        didSet {
            guard let weatherObject = weatherObject else { return }
            viewModel = WeatherInfoViewModel(weatherObject: weatherObject)
            self.viewModel?.delegate = self
            viewModel?.update()
        }
    }
    let tableViewCellID = "locationWeatherCellID"
    let forecastCellID = "locationForecastCellID"
    let collectionViewCellID = "forecastCollectionViewCellID"
    var searchedHistory: [String:WeatherObject]?
    var viewModel: WeatherInfoViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.forecastTableView.register(UINib(nibName: "FiveDaysForecastTableViewCell", bundle: nil), forCellReuseIdentifier: forecastCellID)
        self.forecastTableView.register(UINib(nibName: "CurrentWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: tableViewCellID)
        self.forecastCollectionView.register(UINib(nibName: "OneDayForecastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionViewCellID)
    }
    
    // MARK: - LocationDelegate
    
    func updateWeatherObject(_ weatherObject: WeatherObject) {
        self.weatherObject = weatherObject
    }
    
    // MARK: - ViewModelDelegate
    
    func updateUI() {
        DispatchQueue.main.async {
            self.cityLabel.text = self.viewModel?.cityLabel
            self.temperatureLabel.text = self.viewModel?.temperatureLabel
            self.descriptionLabel.text = self.viewModel?.descriptionLabel
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
                var cell:FiveDaysForecastTableViewCell? = self.forecastTableView.dequeueReusableCell(withIdentifier: forecastCellID) as? FiveDaysForecastTableViewCell
                if cell == nil {
                    cell = FiveDaysForecastTableViewCell(style: .default, reuseIdentifier: forecastCellID)
                }
                if let fiveDayForecast = self.viewModel?.fiveDayForecast {
                    cell?.forecastDetail = fiveDayForecast
                }
                return cell!
            }
            if indexPath.row == 1 {
                var cell:CurrentWeatherTableViewCell? = self.forecastTableView.dequeueReusableCell(withIdentifier: tableViewCellID) as? CurrentWeatherTableViewCell
                if cell == nil {
                    cell = CurrentWeatherTableViewCell(style: .subtitle, reuseIdentifier: tableViewCellID)
                }
                if let wm = self.viewModel {
                    if !wm.tableData.isEmpty && !wm.tabelTitles.isEmpty {
                        cell?.tableData = wm.tableData
                        cell?.tableTitles = wm.tabelTitles
                    }
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
        if let forecastList = self.viewModel?.oneDayForecast {
            return forecastList.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.forecastCollectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath) as! OneDayForecastCollectionViewCell
        if let forecastList = self.viewModel?.oneDayForecast {
            cell.timeLabel?.text = indexPath.row == 0 ? "Now" : forecastList[indexPath.row].dataTime?.toUTC()
            cell.temperature?.text = forecastList[indexPath.row].forecastMain?.temperature?.temperatureToString().celcius()
        }
        
        return cell
    }
}
