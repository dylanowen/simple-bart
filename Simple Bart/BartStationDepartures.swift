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
                self.etds.append(ETD(representation: etdElement, currentTime: self.dateTime))
            }
            
            //filter out missing estimates and sort
            self.etds = self.etds.filter({ $0.estimates.count > 0 }).sort({
                $0.estimates[0].minutes < $1.estimates[0].minutes
            })
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
        let direction: Direction
        
        var estimates: [Estimate] = [Estimate]()
        
        init(representation: AEXMLElement, currentTime: NSDate) {
            self.name = representation["destination"].stringValue
            self.abbr = representation["abbreviation"].stringValue
            
            if let estimates = representation["estimate"].all {
                self.color = estimates[0]["color"].stringValue
                self.hexColor = estimates[0]["hexcolor"].stringValue
                self.direction = Direction(rawValue: estimates[0]["direction"].stringValue.lowercaseString)!
                
                for estimateElement in estimates {
                    //TODO make this better
                    
                    self.estimates.append(Estimate(representation: estimateElement, currentTime: currentTime))
                }
                
                //sort the results
                self.estimates = self.estimates.sort({ $0.minutes < $1.minutes })
            }
            else {
                self.color = "PINK"
                self.hexColor = "#ff00ff"
                self.direction = .North
            }
        }
        
        public class Estimate {
            
            let minutes: Int
            let time: NSDate
            let platform: Int
            let length: Int
            
            let bikeFlag: Bool
            
            init(representation: AEXMLElement, currentTime: NSDate) {
                self.minutes = representation["minutes"].intValue
                self.time = currentTime.dateByAddingTimeInterval(Double(self.minutes) * 60)
                self.platform = representation["platform"].intValue
                self.length = representation["length"].intValue
                self.bikeFlag = representation["bikeFlag"].boolValue
            }
        }
    }
}