//
//  ViewController.swift
//  Logger
//
//  Created by Max Kramer on 09/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import UIKit
import Timber

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.registerFile(.Error)
        
        Logger.debug("This doesn't log")
        Logger.trace("This doesn't log")
        Logger.info("This doesn't log")
        Logger.error("This does log", "so does this")
        Logger.fatal("This does log too")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

