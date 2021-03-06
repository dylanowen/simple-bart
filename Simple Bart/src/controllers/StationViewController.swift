//
//  StationViewController.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/25/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import UIKit

class StationViewController: UITableViewController {
    fileprivate static let dateFormatter = {
        () -> DateFormatter in
        let formatter = DateFormatter()
        //expected date format: 06/25/2016 01:14:33 AM PDT
        formatter.dateFormat = "h:mm:ss a"
        
        return formatter;
    }()
    
    @IBOutlet weak var navigationLabel: UINavigationItem!
    
    var delegate: StationSelector?
    var stationId: String = ""
    
    var etds: [BartStationDepartures.ETD] = []

    /*
    override init(style: UITableViewStyle) {
        super.init(style: style)
        
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.refreshControl = UIRefreshControl()
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshControl = UIRefreshControl()
        
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.tintColor = UIColor(hex: "#ffffff")
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        if self.delegate?.station != nil {
            self.stationId = self.delegate!.station!
            //
            self.navigationLabel.title = self.stationId
            
            //TODO fix this, it shouldn't be there everytime
            refresh(self)
        }
        else {
            //show error
        }
    }
    
    func refresh(_ sender:AnyObject)
    {
        self.refreshControl?.beginRefreshing()
        
        downloadStation()
    }
    
    func downloadStation() {
        BartApi.get.getDepartures(self.stationId, callback: {response in
            if let departures: BartStationDepartures = response.result.value {
                self.navigationLabel.title = departures.name
                self.etds = departures.etds
                
                self.tableView.reloadData()
                
                self.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshed: " + StationViewController.dateFormatter.string(from: departures.dateTime))
                self.refreshControl?.endRefreshing()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.etds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ETDCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ETDCell
        
        // Fetches the appropriate meal for the data source layout.
        let etd = etds[(indexPath as NSIndexPath).row]
        
        cell.setColor(etd.color)
        cell.setDirection(etd.direction)
        cell.stationLabel.text = etd.name
        
        let departures = etd.estimates.map({ $0.time })
        cell.setDepartures(departures)
        
        /*
        var departures = "Departures:"
        for estimate in etd.estimates {
            departures += " \(estimate.minutes)m"
        }
 */
        
        //cell.departuresLabel.text = departures
        
        return cell
    }
}

