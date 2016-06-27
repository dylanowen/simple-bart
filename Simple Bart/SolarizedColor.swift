//
//  SolarizedColor.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/26/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import UIKit

struct SolarizedColor {
    let rawValue: String
    let hexCode: String
    let color: UIColor
    
    private init(_ rawValue:String, _ hexCode:String) {
        self.rawValue = rawValue
        self.hexCode = hexCode
        self.color = UIColor(hex: hexCode)
    }
}

extension SolarizedColor {
    static let Red = SolarizedColor("red", "#dc322f")
    static let Orange = SolarizedColor("orange", "#cb4b16")
    static let Yellow = SolarizedColor("yellow", "#b58900")
    static let Green = SolarizedColor("green", "#859900")
    static let Blue = SolarizedColor("blue", "#268bd2")
    static let Magenta = SolarizedColor("magenta", "#d33682")
    static let Violet = SolarizedColor("violet", "#6c71c4")
    static let Cyan = SolarizedColor("cyan", "#2aa198")
    static let Default = SolarizedColor("", "#000000")
    static let allColors = [Red, Orange, Yellow, Green, Blue, Magenta, Violet, Cyan]
    
    static func getColor(colorName: String) -> SolarizedColor {
        let normalizedName = colorName.lowercaseString
        
        for color in allColors {
            if (color.rawValue == normalizedName) {
                return color
            }
        }
        
        return Default
    }
}

//copied from ttp://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
extension UIColor {
    
    convenience init(hex: String) {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            self.init(red: 255, green: 0, blue: 255, alpha: 1)
        }
        else {
            var rgbValue:UInt32 = 0
            NSScanner(string: cString).scanHexInt(&rgbValue)
            
            let components = (
                R: CGFloat((rgbValue >> 16) & 0xff) / 255,
                G: CGFloat((rgbValue >> 08) & 0xff) / 255,
                B: CGFloat((rgbValue >> 00) & 0xff) / 255
            )
            
            self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
        }
    }
    
}