//
//  HistoryVC.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 02/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import UIKit
import Disk

class HistoryVC: UIViewController, HistoryViewModelDelegate {
    
    @IBOutlet weak var historySearchBar: UISearchBar!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var deleteCacheButton: UIButton!
    let cellID = "historyCellID"
    var searchHistory: [String:WeatherObject]?
    var weatherObject: WeatherObject?
    var viewModel: HistoryViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.historyTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.historySearchBar.delegate = self
        self.load()
    }
    
    // MARK: - Private

    func load() {
        do {
            self.searchHistory = try Disk.retrieve("SearchedCities", from: .caches, as: [String:WeatherObject].self)
            self.viewModel = HistoryViewModel(searchedHistory: self.searchHistory)
            self.viewModel?.delegate = self
            self.viewModel?.updateTableView()
        } catch {
            print(error)
        }
    }
    
    func updateButton(_ isEnabled: Bool) {
        self.deleteCacheButton.isEnabled = isEnabled
    }
    
    // MARK: - Actions
    
    @IBAction func onDeleteCache(_ sender: UIButton) {
        self.viewModel?.delete()
    }
    
    // MARK: - HistoryViewModelDelegate
    
    func updateUI() {
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
            self.updateButton(self.viewModel?.buttonEnabled ?? false)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "historyDetail") {
            let destinationVC = segue.destination as! HistoryDetailVC
            if let weather = self.weatherObject {
                destinationVC.weatherObject = weather
            }
        }
    }
}

extension HistoryVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.viewModel?.update(searchedText: searchText)        
    }        
}

extension HistoryVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filtered = self.viewModel?.filteredHistory {
            return filtered.count
        }
        if let searchHistory = self.viewModel?.searchHistory {
                return searchHistory.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.historyTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        if let cities = self.viewModel?.cities, let countries = self.viewModel?.countries {
            if !cities.isEmpty && !countries.isEmpty {
                cell.textLabel?.text = cities[indexPath.row]
                cell.detailTextLabel?.text = countries[indexPath.row]
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let key = self.viewModel?.cities?[indexPath.row] {
            self.weatherObject = self.viewModel?.searchHistory?[key]
            performSegue(withIdentifier: "historyDetail", sender: self)
        }
    }
}
