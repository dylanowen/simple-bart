//
//  ETDCell.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/25/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import UIKit

class ETDCell: UITableViewCell {
    fileprivate static let dateFormatter = {
        () -> DateFormatter in
        let formatter = DateFormatter()
        
        //expected date format: 06/25/2016 01:14:33 AM PDT
        formatter.dateFormat = "h:mma"
        formatter.amSymbol = "a"
        formatter.pmSymbol = "p"
        
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setColor(_ color: UIColor) {
        //self.colorBox.backgroundColor = UIColor(hex: "#000000")
        self.directionLabel.textColor = color
    }
    
    func setDirection(_ direction: Direction) {
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
    
    func setDepartures(_ departures: [Date]) {
        var departureString = ""
        for estimate in departures {
            departureString += "\(ETDCell.dateFormatter.string(from: estimate))   "
        }
        
        self.departuresLabel.text = departureString
    }
}
