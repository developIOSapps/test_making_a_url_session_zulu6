//
//  ViewController.swift
//  Login App
//
//  Created by Steven Hertz on 11/26/19.
//  Copyright © 2019 DevelopItSolutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performSegue(withIdentifier: "loginScreen", sender: nil)
    }
    
    
    // @IBAction func segueNext


}

