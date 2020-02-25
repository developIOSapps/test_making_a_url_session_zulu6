//
//  HeaderTableViewCell.swift
//  Template Categories
//
//  Created by Steven Hertz on 2/17/20.
//  Copyright © 2020 DevelopItSolutions. All rights reserved.
//

import UIKit

protocol GestureRecognizerDelegate {
    func proccesSwipe(with swipeGestureRecognizer: UISwipeGestureRecognizer)
}

class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var delegate: GestureRecognizerDelegate?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        backgroundColor = .white
        
        addGestureRecognizers()
    }
    
    func setup(with appCatg: AppCategory)  {
        titleLabel.text = appCatg.name
        descriptionLabel.text = appCatg.description
        if #available(iOS 13.0, *) {
            iconImageView.image = UIImage(systemName: appCatg.iconName)
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func addGestureRecognizers() {
        
        let leftSwipeGesture: UISwipeGestureRecognizer = {
            let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(swipe:)))
            gestureRecognizer.direction = .left
            return gestureRecognizer
        }()
        addGestureRecognizer(leftSwipeGesture)
        
        
        let rightSwipeGesture: UISwipeGestureRecognizer = {
            let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(swipe:)))
            gestureRecognizer.direction = .right
            return gestureRecognizer
        }()
        addGestureRecognizer(rightSwipeGesture)
    }
    
    @objc func handleSwipes(swipe: UISwipeGestureRecognizer) {
        
        if swipe.direction == .left {
            print("it was left")
        }
        if swipe.direction == .right {
            print("it was right")
        }
        
        delegate?.proccesSwipe(with: swipe)
        
    }
    
    
}


