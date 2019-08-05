//
//  OneDayForecastTableViewCell.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 04/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import UIKit

class OneDayForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var forecastTableView: UITableView!
    var forecastDetail: [ForecastListDetail]? {
        didSet {
            DispatchQueue.main.async {
                self.forecastTableView.reloadData()
            }
        }
    }
    let cellID = "oneDayForecastTableViewCellID"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpTable()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        setUpTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
    }
    
    func setUpTable() {
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        forecastTableView.isScrollEnabled = true
        forecastTableView.frame = self.bounds
        forecastTableView.register(UINib(nibName: "CustomForecastTableviewCell", bundle: nil), forCellReuseIdentifier: cellID)
        forecastTableView.tableFooterView = UIView(frame: .zero)
    }
}

extension OneDayForecastTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let forecastDetail = self.forecastDetail {
            return forecastDetail.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = forecastTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomForecastTableviewCell
        if let forecastDetail = self.forecastDetail {
            cell.dayLabel.text = forecastDetail[indexPath.row].dataTime?.dayOfTheWeek()
            cell.minTemperatureLabel.text = forecastDetail[indexPath.row].forecastMain?.minTemperature?.toString()
            cell.maxTemperatureLabel.text = forecastDetail[indexPath.row].forecastMain?.maxTemperature?.toString()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
