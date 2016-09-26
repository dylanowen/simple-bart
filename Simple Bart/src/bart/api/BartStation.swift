//
//  BartStation.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/25/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import Foundation


import AEXML

open class BartStation: AbstractBartStation {
    
    let latitude: Double
    let longitude: Double
    let address:String
    let city: String
    let county: String
    let state: String
    let zipCode: String
    
    public override init(representation: AEXMLElement) {
        self.latitude = representation["latitude"].double
        self.longitude = representation["longitude"].double
        self.address = representation["address"].string
        self.city = representation["city"].string
        self.county = representation["county"].string
        self.state = representation["state"].string
        self.zipCode = representation["zipCode"].string
        
        super.init(representation: representation)
    }
}
