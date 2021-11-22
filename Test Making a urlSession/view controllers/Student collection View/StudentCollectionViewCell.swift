//
//  StudentCollectionViewCell.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/21/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit

class StudentCollectionViewCell: UICollectionViewCell {
    
    //@IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var studentImageView: UIImageView!
    
    @IBOutlet weak var studentNameLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var checkmarkImageView: UIImageView! {
        didSet {
            checkmarkImageView.alpha = 0.0
            let tintableImage = checkmarkImageView.image?.withRenderingMode(.alwaysTemplate)
            print("set it tintable")
            checkmarkImageView.image = tintableImage
            // checkmarkImageView.tintColor = UIColor(named: "tintcontrast")

           //  checkImage.image = UIImage(systemName: <#T##String#>, withConfiguration: UIImage.Configuration?)  //UIImage(imageLiteralResourceName: "myImageName").withRenderingMode(.alwaysTemplate)
            // checkImage.tintColor = UIColor.red
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let redView = UIView(frame: bounds)
//        redView.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
//        backgroundView = redView
//
//        let blueView = UIView(frame: bounds)
//        blueView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
//        selectedBackgroundView = blueView
        
        
        studentImageView.layer.cornerRadius = 60
        studentImageView.layer.masksToBounds = true
        
        activityIndicator.startAnimating()
    }
    
    
    func showIcon() {
        checkmarkImageView.alpha = 1.0
        studentImageView.alpha = 0.5
    }

    func hideIcon() {
        checkmarkImageView.alpha = 0.0
        studentImageView.alpha = 1.0
    }
    
    func update(displaying image: UIImage?) {
        activityIndicator.stopAnimating()
        if let imageToDisplay = image {
            // spinner.stopAnimating()
            studentImageView.image = imageToDisplay
        } else {
            // spinner.startAnimating()
            studentImageView.image = nil
        }
    }
    
}

