//
//  ETDCell.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/25/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import UIKit

class ETDCell: UITableViewCell {
    private static let dateFormatter = {
        () -> NSDateFormatter in
        let formatter = NSDateFormatter()
        
        //expected date format: 06/25/2016 01:14:33 AM PDT
        formatter.dateFormat = "h:mm"
        
        return formatter;
    }()
   
    @IBOutlet weak var colorBox: UIView!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var departuresLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setColor(hexColor: String) {
        self.colorBox.backgroundColor = UIColor(hex: hexColor)
    }
    
    func setDirection(direction: Direction) {
        let arrow: String
        switch direction {
        case .North:
            arrow = "↑"
            break
        case .East:
            arrow = "→"
            break
        case .South:
            arrow = "↓"
            break
        case .West:
            arrow = "←"
            break
        }
        
        self.directionLabel.text = arrow
    }
    
    func setDepartures(departures: [NSDate]) {
        var departureString = ""
        for estimate in departures {
            departureString += "\(ETDCell.dateFormatter.stringFromDate(estimate))   "
        }
        
        self.departuresLabel.text = departureString
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