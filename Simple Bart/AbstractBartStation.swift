//
//  BartStation.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/25/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import Foundation

import AEXML

public class AbstractBartStation {
    //station
    let name: String
    let abbr: String
    
    init(representation: AEXMLElement) {
        self.name = representation["name"].stringValue
        self.abbr = representation["abbr"].stringValue
    }
}