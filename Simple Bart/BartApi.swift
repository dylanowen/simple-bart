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
    static let userDefaults = NSUserDefaults.standardUserDefaults()
    static let get = BartApi()
    
    private static let key = { () -> String in
        let path = NSBundle.mainBundle().pathForResource("keys", ofType: "plist")!
        let keysConfig = NSDictionary(contentsOfFile: path)!
        
        return keysConfig["BART_API_KEY"] as! String
    }()
    
    private init() {
        print("Using key: " + BartApi.key)
    }
    
    func getStations(cached: Bool = true, callback: Response<AllBartStations, BackendError> -> Void) {
        let request = buildRequest("stn", parameters: ["cmd": "stns"])
        
        request.responseObject(callback)
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
    
    func getDefaultStations() -> [(abbr: String, name: String)] {
        return [
            (abbr: "12TH", name: "12th St. Oakland City Center"),
            (abbr: "16TH", name: "16th St. Mission"),
            (abbr: "19TH", name: "19th St. Oakland"),
            (abbr: "24TH", name: "24th St. Mission"),
            (abbr: "ASHB", name: "Ashby"),
            (abbr: "BALB", name: "Balboa Park"),
            (abbr: "BAYF", name: "Bay Fair"),
            (abbr: "CAST", name: "Castro Valley"),
            (abbr: "CIVC", name: "Civic Center/UN Plaza"),
            (abbr: "COLS", name: "Coliseum"),
            (abbr: "COLM", name: "Colma"),
            (abbr: "CONC", name: "Concord"),
            (abbr: "DALY", name: "Daly City"),
            (abbr: "DBRK", name: "Downtown Berkeley"),
            (abbr: "DUBL", name: "Dublin/Pleasanton"),
            (abbr: "DELN", name: "El Cerrito del Norte"),
            (abbr: "PLZA", name: "El Cerrito Plaza"),
            (abbr: "EMBR", name: "Embarcadero"),
            (abbr: "FRMT", name: "Fremont"),
            (abbr: "FTVL", name: "Fruitvale"),
            (abbr: "GLEN", name: "Glen Park"),
            (abbr: "HAYW", name: "Hayward"),
            (abbr: "LAFY", name: "Lafayette"),
            (abbr: "LAKE", name: "Lake Merritt"),
            (abbr: "MCAR", name: "MacArthur"),
            (abbr: "MLBR", name: "Millbrae"),
            (abbr: "MONT", name: "Montgomery St."),
            (abbr: "NBRK", name: "North Berkeley"),
            (abbr: "NCON", name: "North Concord/Martinez"),
            (abbr: "OAKL", name: "Oakland Int'l Airport"),
            (abbr: "ORIN", name: "Orinda"),
            (abbr: "PITT", name: "Pittsburg/Bay Point"),
            (abbr: "PHIL", name: "Pleasant Hill/Contra Costa Centre"),
            (abbr: "POWL", name: "Powell St."),
            (abbr: "RICH", name: "Richmond"),
            (abbr: "ROCK", name: "Rockridge"),
            (abbr: "SBRN", name: "San Bruno"),
            (abbr: "SFIA", name: "San Francisco Int'l Airport"),
            (abbr: "SANL", name: "San Leandro"),
            (abbr: "SHAY", name: "South Hayward"),
            (abbr: "SSAN", name: "South San Francisco"),
            (abbr: "UCTY", name: "Union City"),
            (abbr: "WCRK", name: "Walnut Creek"),
            (abbr: "WDUB", name: "West Dublin/Pleasanton"),
            (abbr: "WOAK", name: "West Oakland"),
        ]
    }
}