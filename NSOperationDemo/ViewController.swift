//
//  ViewController.swift
//  NSOperationDemo
//
//  Created by Ravi Shankar on 01/04/16.
//  Copyright © 2016 Ravi Shankar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func callService(sender: AnyObject) {
        let serviceManager = ServiceManager()
        serviceManager.makeServiceCall("US")
    }
}

