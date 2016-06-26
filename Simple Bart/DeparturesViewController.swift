//
//  SecondViewController.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/21/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import UIKit

class DeparturesViewController: UITableViewController, StationSelector {
    var station: String? = nil
    var stations = BartApi.get.getDefaultStations()
    
    /*
    @IBAction func oakDepartures(sender: AnyObject) {
        self.station = "12th"
        
        performSegueWithIdentifier("showStation", sender: self)
    }
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         bartApi.getDepartures("12th", callback: {response in
         print(response)
         })
         */
        //test.add
        
        //print(bartApi)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "StationCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StationCell
        
        // Fetches the appropriate meal for the data source layout.
        let station = self.stations[indexPath.row]
        
        cell.stationLabel.text = station.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let station = self.stations[indexPath.row]
        
        self.station = station.abbr
        
        performSegueWithIdentifier("showStation", sender: self)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let stationController = segue.destinationViewController as? StationViewController {
            stationController.delegate = self
        }
    }    
}

