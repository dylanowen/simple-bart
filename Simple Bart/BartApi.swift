//
//  BartApi.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/21/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import Foundation

import Alamofire

class BartApi {
    static let get = BartApi()
    
    private static let key = { () -> String in
        let path = NSBundle.mainBundle().pathForResource("keys", ofType: "plist")!
        let keysConfig = NSDictionary(contentsOfFile: path)!
        
        return keysConfig["BART_API_KEY"] as! String
    }()
    
    private init() {
        print("Using key: " + BartApi.key)
    }
    
    func getDepartures(origin: String, callback: Response<BartStationDepartures, BackendError> -> Void) {
        //ttp://api.bart.gov/api/etd.aspx?cmd=etd&orig=12th&key=MW9S-E7SL-26DU-VV8V
        let request = buildRequest("etd", parameters: ["cmd": "etd", "orig": origin])
        
        request.responseObject(callback)
    }
    
    private func buildRequest(path: String, parameters: [String: String] = [:]) -> Request  {
        var finalParms = parameters
        finalParms["key"] = BartApi.key
        
        return Alamofire.request(.GET, "https://api.bart.gov/api/" + path + ".aspx", parameters: finalParms)
    }
}