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
    private static let key = { () -> String in
        let path = NSBundle.mainBundle().pathForResource("keys", ofType: "plist")!
        let keysConfig = NSDictionary(contentsOfFile: path)!
        
        return keysConfig["BART_API_KEY"] as! String
    }()
    
    init() {
        print("Using key: " + BartApi.key)
    }
    
    func getDepartures() {
        //ttp://api.bart.gov/api/etd.aspx?cmd=etd&orig=12th&key=MW9S-E7SL-26DU-VV8V
        let request = buildRequest("etd", parameters: ["cmd": "etd", "orig": "12th"])
        
        request.responseObject({(response: Response<BartDepartures, BackendError>) in
            print(response.result.error)
            print(response.result.value)
        })
        //request.responseXMLDocument({response in print(response.result.value)})
    }
    
    private func buildRequest(path: String, parameters: [String: String] = [:]) -> Request  {
        var finalParms = parameters
        finalParms["key"] = BartApi.key
        
        return Alamofire.request(.GET, "https://api.bart.gov/api/" + path + ".aspx", parameters: finalParms)
    }
}