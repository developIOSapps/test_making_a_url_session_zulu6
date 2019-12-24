//
//  ViewController.swift
//  Login App
//
//  Created by Steven Hertz on 11/26/19.
//  Copyright © 2019 DevelopItSolutions. All rights reserved.
//

import UIKit

class Viewontroller: UIViewController {
    
    var grpCd = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if grpCd == 0 {
            performSegue(withIdentifier: "loginScreen", sender: nil)
        }
        
    }
    
    @IBAction func returnWithClass(segue: UIStoryboardSegue) {
        guard let vc = segue.source as? LoginViewController, let groupID = vc.groupID else { return  }
        grpCd = groupID
        print("Returned from Segue \(grpCd)")

    }
    
    
    // @IBAction func segueNext


}

