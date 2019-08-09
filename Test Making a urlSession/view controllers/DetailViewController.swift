//
//  DetailViewController.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 6/16/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var members: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    
    var deviceGroup : DeviceGroup!

    override func viewDidLoad() {
        super.viewDidLoad()
        desc.text = deviceGroup.description
        members.text = String(deviceGroup.members)
        type.text = deviceGroup.type
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
