//
//  SecondViewController.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/21/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import UIKit

class DeparturesViewController: UIViewController {

    private let bartApi = BartApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bartApi.getDepartures()
        //print(bartApi)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

