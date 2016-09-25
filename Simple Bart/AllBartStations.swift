//
//  AllBartStations.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/25/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import Foundation

import AEXML

open class AllBartStations: ResponseXMLSerializable {

    var stations: [BartStation] = [BartStation]()
    
    required public init(response: HTTPURLResponse, representation: AEXMLDocument) {
        //print(representation)
        
        let root = representation.root;
        
        if let stations = root["stations"]["station"].all {
            for stationElement in stations {
                self.stations.append(BartStation(representation: stationElement))
            }
        }

    }
}
