//
//  TextBasedWeatherVC.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 02/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import UIKit
import MapKit

class TextBasedWeatherVC: UIViewController, UITextFieldDelegate {
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults: [MKLocalSearchCompletion]?    
    let cellID = "cityCellID"
    let wm = WeatherManager()
    var currentWeather: CurrentWeather?
    var forecast: Forecast?
    var weatherObject: WeatherObject?
    var city = ""
    @IBOutlet weak var cityResultsTableView: UITableView!
    @IBOutlet weak var cityTextField: UITextField!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityTextField.becomeFirstResponder()
        self.createToolbar()
        self.searchCompleter.delegate = self
        self.cityResultsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.reset()
    }
    
    // MARK: - Actions
        
    @IBAction func onCurrentWeather(_ sender: UIButton) {        
        if city.isEmpty {
            self.handleError()
        } else {
            self.fetchWeather(city: self.city)
        }
    }
    
    func fetchWeather(city: String){
        let dispatchGroup = DispatchGroup()
        let queueImage = DispatchQueue(label: "com.currentWeather")
        let queueVideo = DispatchQueue(label: "com.forecast")
        
        dispatchGroup.enter()
        queueImage.async(group: dispatchGroup) {
            self.wm.getFiveDaysForecastForCity(city) { (forecast, error) in
                if let forecast = forecast {
                    self.forecast = forecast
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.enter()
        queueVideo.async(group: dispatchGroup) {
            self.wm.getCurrentWeatherForCity(city, completion: { (weather, error) in
                if let weather = weather {
                    self.currentWeather = weather
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            if let weather = self.currentWeather, let forecast = self.forecast {
                let wo = WeatherObject(weather: weather, forecast: forecast)
                self.weatherObject = wo
                self.performSegue(withIdentifier: "textBasedCurrentWeather", sender: self)
            }
        }
    }
    
    // MARK: - Update UI
    
    func handleError() {
        DispatchQueue.main.async {            
            let ac = UIAlertController.init(title: "Missing location", message:  "Select valid city, please.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { ( action ) in
                ac.dismiss(animated: true, completion: nil)
            }))
            self.present(ac, animated: true, completion: nil)
        }
    }

    func reloadTableView() {
        DispatchQueue.main.async {
            self.cityResultsTableView.reloadData()
        }
    }
    
    // MARK: - Private
    
    func reset() {
        self.currentWeather = nil
        self.cityTextField.text = nil
        self.searchCompleter.queryFragment = self.cityTextField.text!
        self.searchResults?.removeAll()
        self.reloadTableView()
    }
    
    func createToolbar(){
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = UIColor.white
        toolBar.tintColor = UIColor.init(red: 47/255, green: 171/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.cityTextField.inputAccessoryView = toolBar
    }
    
    @objc func onDone() {
        self.cityTextField.resignFirstResponder()
    }
    
    // MARK: - Textfield delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let city = textField.text {
            self.searchCompleter.queryFragment = city
        }
        if (range.location == 0 && string.count == 0) {
            self.searchCompleter.queryFragment = ""
        }
        
        return true
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "textBasedCurrentWeather") {
            let vc = segue.destination as! TextBasedWeatherDetailVC
            if let wo = self.weatherObject {
                vc.weatherObject = wo
            }
        }
    }
}

extension TextBasedWeatherVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.cityResultsTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = self.searchResults?[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cityTextField.resignFirstResponder()
        self.cityTextField.text = self.searchResults?[indexPath.row].title
        self.city = self.cityTextField.text!
        self.cityResultsTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TextBasedWeatherVC: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        self.reloadTableView()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        searchResults = nil
        self.reloadTableView()
    }
}
