//
//  StudentCollectionViewCell.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/21/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit

class StudentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var studentImageView: UIImageView!
    
    @IBOutlet weak var studentNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //selectedBackgroundView = UIView()
        //selectedBackgroundView?.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        studentImageView.layer.cornerRadius = 60
        studentImageView.layer.masksToBounds = true
    }

}
