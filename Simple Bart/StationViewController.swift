//
//  StationViewController.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/25/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import UIKit

class StationViewController: UITableViewController {
    @IBOutlet weak var navigationLabel: UINavigationItem!
    
    var delegate: StationSelector?
    var stationId: String = ""
    
    var etds: [BartStationDepartures.ETD] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.addSubview(refreshControl!)
        
        if self.delegate?.station != nil {
            self.stationId = self.delegate!.station!
            //
            self.navigationLabel.title = self.stationId
            
            downloadStation()
        }
        else {
            //show error
        }
        
        
        //print(bartApi)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        
        downloadStation()
        
        refreshControl?.endRefreshing()
    }
    
    func downloadStation() {
        BartApi.get.getDepartures(self.stationId, callback: {response in
            if let departures: BartStationDepartures = response.result.value {
                self.navigationLabel.title = departures.name
                self.etds = departures.etds
                
                self.tableView.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.etds.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ETDCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ETDCell
        
        // Fetches the appropriate meal for the data source layout.
        let etd = etds[indexPath.row]
        
        cell.colorBox.backgroundColor = UIColor(hex: etd.hexColor)
        cell.stationLabel.text = etd.name
        
        var departures = "Departures:"
        for estimate in etd.estimates {
            departures += " \(estimate.minutes)m"
        }
        
        cell.departuresLabel.text = departures
        
        return cell
    }
}

//copied from ttp://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
extension UIColor {
    
    convenience init(hex: String) {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            self.init(red: 255, green: 0, blue: 255, alpha: 1)
        }
        else {
            var rgbValue:UInt32 = 0
            NSScanner(string: cString).scanHexInt(&rgbValue)
            
            let components = (
                R: CGFloat((rgbValue >> 16) & 0xff) / 255,
                G: CGFloat((rgbValue >> 08) & 0xff) / 255,
                B: CGFloat((rgbValue >> 00) & 0xff) / 255
            )
            
            self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
        }
    }
    
}