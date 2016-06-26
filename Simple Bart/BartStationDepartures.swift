//
//  BartDeparture.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/21/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import Foundation

import AEXML

public class BartStationDepartures: AbstractBartStation, ResponseXMLSerializable {
    private static let dateFormatter = {
        () -> NSDateFormatter in
            let formatter = NSDateFormatter()
            //expected date format: 06/25/2016 01:14:33 AM PDT
            formatter.dateFormat = "MM/dd/yyyy hh:mm:ss a zzz"
            
            return formatter;
    }()
    
    //datetime
    let dateString: String
    let timeString: String
    let dateTime: NSDate
    
    var etds: [ETD] = [ETD]()
    
    required public init(response: NSHTTPURLResponse, representation: AEXMLDocument) {
        //print(representation)
        
        let root = representation.root;
        
        //capture the date time and parse the value
        self.dateString = root["date"].stringValue
        self.timeString = root["time"].stringValue
        self.dateTime = BartStationDepartures.dateFormatter.dateFromString(self.dateString + " " + self.timeString) ?? NSDate()
        
        let station = root["station"]
        super.init(representation: station)
        
        if let etds = station["etd"].all {
            for etdElement in etds {
                self.etds.append(ETD(representation: etdElement))
            }
        }
        
        //print(self.dateTime)
    }

    //TODO is this a good idea?
    public class ETD {
     
        //station
        let name: String
        let abbr: String
        let color: String
        let hexColor: String
        
        var estimates: [Estimate] = [Estimate]()
        
        init(representation: AEXMLElement) {
            self.name = representation["destination"].stringValue
            self.abbr = representation["abbreviation"].stringValue
            
            if let estimates = representation["estimate"].all {
                self.color = estimates[0]["color"].stringValue
                self.hexColor = estimates[0]["hexcolor"].stringValue
                
                for estimateElement in estimates {
                    //TODO make this better
                    
                    self.estimates.append(Estimate(representation: estimateElement))
                }
            }
            else {
                self.color = "PINK"
                self.hexColor = "#ff00ff"
            }
        }
        
        public class Estimate {
            
            let minutes: Int
            let platform: Int
            let direction: Direction
            let length: Int
            
            let bikeFlag: Bool
            
            init(representation: AEXMLElement) {
                self.minutes = representation["minutes"].intValue
                self.platform = representation["platform"].intValue
                self.direction = Direction(rawValue: representation["direction"].stringValue.lowercaseString)!
                self.length = representation["length"].intValue
                self.bikeFlag = representation["bikeFlag"].boolValue
            }
        }
    }
}