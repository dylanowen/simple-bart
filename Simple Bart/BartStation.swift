//
//  BartStation.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/25/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import Foundation


import AEXML

public class BartStation: AbstractBartStation {
    
    let latitude: Double
    let longitude: Double
    let address:String
    let city: String
    let county: String
    let state: String
    let zipCode: String
    
    public override init(representation: AEXMLElement) {
        self.latitude = representation["latitude"].doubleValue
        self.longitude = representation["longitude"].doubleValue
        self.address = representation["address"].stringValue
        self.city = representation["city"].stringValue
        self.county = representation["county"].stringValue
        self.state = representation["state"].stringValue
        self.zipCode = representation["zipCode"].stringValue
        
        super.init(representation: representation)
    }
}