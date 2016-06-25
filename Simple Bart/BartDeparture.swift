//
//  BartDeparture.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/21/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import Foundation

import AEXML

class BartDepartures: BartResponse, ResponseXMLSerializable {
    private static let dateFormatter = {
        () -> NSDateFormatter in
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd/yyyy hh:mm:ss a zzz"
            
            return formatter;
    }()
    
    let dateString: String
    let timeString: String
    let dateTime: NSDate
    
    required init(response: NSHTTPURLResponse, representation: AEXMLDocument) {
        //print(representation)
        
        let root = representation.root;
        
        //capture the date time and parse the value
        self.dateString = root["date"].stringValue
        self.timeString = root["time"].stringValue
        self.dateTime = BartDepartures.dateFormatter.dateFromString(self.dateString + " " + self.timeString) ?? NSDate()
        
        print(self.dateTime)
    }

    //TODO is this a good idea?
    class ETD {
     
        
        class Estimate {
            
        }
    }
}