//
//  SecondViewController.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/21/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import UIKit

class DeparturesViewController: UIViewController, StationSelector {
    var station: String? = nil
    
    @IBAction func oakDepartures(sender: AnyObject) {
        self.station = "12th"
        
        performSegueWithIdentifier("showStation", sender: self)
    }
    
    @IBAction func sfDepartures(sender: AnyObject) {
        self.station = "embr"
        
        performSegueWithIdentifier("showStation", sender: self)
    }
    
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

