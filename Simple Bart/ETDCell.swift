//
//  ETDCell.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/25/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import UIKit

class ETDCell: UITableViewCell {
   
    @IBOutlet weak var colorBox: UIView!
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
    
}