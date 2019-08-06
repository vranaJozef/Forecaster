//
//  CurrentWeatherTableViewCell.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 04/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import UIKit

class CurrentWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var fiveDaysForecastTableView: UITableView!
    var tableTitles: [String]?
    var tableData: [String:String]? {
        didSet {
            DispatchQueue.main.async {
                self.fiveDaysForecastTableView.reloadData()
            }
        }
    }
    let cellID = "CurrentWeatherTableViewCellID"
    
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
        fiveDaysForecastTableView.delegate = self
        fiveDaysForecastTableView.dataSource = self
        fiveDaysForecastTableView.isScrollEnabled = true
        fiveDaysForecastTableView.frame = self.bounds
        fiveDaysForecastTableView.register(UINib(nibName: "CustomCurrentWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        fiveDaysForecastTableView.tableFooterView = UIView(frame: .zero)
    }
}

extension CurrentWeatherTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let forecastDetail = self.tableData {
            return forecastDetail.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fiveDaysForecastTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomCurrentWeatherTableViewCell
        if let forecastDetail = self.tableData, let titles = self.tableTitles {
            cell.typeLabel?.text = titles[indexPath.row]
            cell.typeDetailLabel?.text = forecastDetail[titles[indexPath.row]]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
