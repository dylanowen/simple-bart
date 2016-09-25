//
//  BartDeparture.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/21/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import Foundation

import AEXML

open class BartStationDepartures: AbstractBartStation, ResponseXMLSerializable {
    fileprivate static let dateFormatter = {
        () -> DateFormatter in
            let formatter = DateFormatter()
            //expected date format: 06/25/2016 01:14:33 AM PDT
            formatter.dateFormat = "MM/dd/yyyy hh:mm:ss a zzz"
            
            return formatter;
    }()
    
    //datetime
    let dateString: String
    let timeString: String
    let dateTime: Date
    
    var etds: [ETD] = [ETD]()
    
    required public init(response: HTTPURLResponse, representation: AEXMLDocument) {
        //print(representation)
        
        let root = representation.root;
        
        //capture the date time and parse the value
        self.dateString = root["date"].string
        self.timeString = root["time"].string
        self.dateTime = BartStationDepartures.dateFormatter.date(from: self.dateString + " " + self.timeString) ?? Date()
        
        let station = root["station"]
        super.init(representation: station)
        
        if let etds = station["etd"].all {
            for etdElement in etds {
                self.etds.append(ETD(representation: etdElement, currentTime: self.dateTime))
            }
            
            //filter out missing estimates and sort
            self.etds = self.etds.filter({ $0.estimates.count > 0 }).sorted(by: {
                $0.estimates[0].minutes < $1.estimates[0].minutes
            })
        }
        
        //print(self.dateTime)
    }

    //TODO is this a good idea?
    open class ETD {
     
        //station
        let name: String
        let abbr: String
        let hexColor: String
        let color: UIColor
        let direction: Direction
        
        var estimates: [Estimate] = [Estimate]()
        
        init(representation: AEXMLElement, currentTime: Date) {
            self.name = representation["destination"].string
            self.abbr = representation["abbreviation"].string
            
            if let estimates = representation["estimate"].all {
                self.hexColor = estimates[0]["hexcolor"].string
                
                self.direction = Direction(rawValue: estimates[0]["direction"].string.lowercased())!
                
                for estimateElement in estimates {
                    //TODO make this better
                    
                    self.estimates.append(Estimate(representation: estimateElement, currentTime: currentTime))
                }
                
                //sort the results
                self.estimates = self.estimates.sorted(by: { $0.minutes < $1.minutes })
            }
            else {
                self.hexColor = "#000000"
                self.direction = .North
            }
            
            self.color = UIColor(hex: self.hexColor)
        }
        
        open class Estimate {
            
            let minutes: Int
            let time: Date
            let platform: Int
            let length: Int
            
            let bikeFlag: Bool
            
            init(representation: AEXMLElement, currentTime: Date) {
                self.minutes = representation["minutes"].int
                self.time = currentTime.addingTimeInterval(Double(self.minutes) * 60)
                self.platform = representation["platform"].int
                self.length = representation["length"].int
                self.bikeFlag = representation["bikeFlag"].bool
            }
        }
    }
}
