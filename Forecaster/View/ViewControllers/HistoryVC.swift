//
//  HistoryVC.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 02/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import UIKit
import Disk

class HistoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var historySearchBar: UISearchBar!
    @IBOutlet weak var historyTableView: UITableView!
    let cellID = "historyCellID"
    var searchHistory: [String:String]?
    var cities: [String]?
    var countries: [String]?
    var filteredCities: [String]?
    var filteredHistory: [String:String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.historySearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            self.searchHistory = try Disk.retrieve("SearchedCities", from: .caches, as: [String:String].self)
        } catch {
            print(error)
        }
        self.reloadTable()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            
            if let searchHistory = self.searchHistory {
                self.filteredCities = [String]()
                for (city, _) in searchHistory {
                    self.filteredCities?.append(city)
                }
                
                if let cities = self.filteredCities {
                    self.filteredCities = searchText.isEmpty ? cities : cities.filter { $0.contains(searchText) }
                    
                    if let filteredCities = self.filteredCities {
                        self.filteredHistory = [String:String]()
                        for filteredName in filteredCities {
                            if let country = searchHistory[filteredName] {
                                self.filteredHistory![filteredName] = country
                            } else {
                                self.filteredHistory![filteredName] = ""
                            }
                        }
                    }
                    self.reloadTable()
                }
            }
        } else {
            self.filteredHistory = nil
            self.reloadTable()
        }
    }
    
    func reloadTable() {
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
                    countries?.append(country)
                }
            }
        }
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filtered = self.filteredHistory {
            return filtered.count
        }
        if let searchHistory = self.searchHistory {
                return searchHistory.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.historyTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        if let cities = self.cities, let countries = self.countries {
            cell.textLabel?.text = cities[indexPath.row]
            cell.detailTextLabel?.text = countries[indexPath.row]
        }
        
        return cell
    }    
}
