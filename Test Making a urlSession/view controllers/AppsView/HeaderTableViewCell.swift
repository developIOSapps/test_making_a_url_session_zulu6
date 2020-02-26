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
    func proccesTap(tap: UITapGestureRecognizer)
}

class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nextImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var selectButton: DesignableButton!
    
    var delegate: GestureRecognizerDelegate?
    var tbldelegate: AppTableViewDelegate?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //accessoryType = .disclosureIndicator
        selectionStyle = .none
        backgroundColor = .white
        
        addGestureRecognizers()
    }
    
    func setup(with appCatg: AppCategory, studentOrDevice itemsToDisplay: AppTableViewController.ItemsToDisplay)  {
        titleLabel.text = appCatg.name
        descriptionLabel.text = appCatg.description
        if #available(iOS 13.0, *) {
            iconImageView.image = UIImage(systemName: appCatg.iconName)
        } else {
            // Fallback on earlier versions
        }
        switch itemsToDisplay {
        case .devices:
            selectButton.isHidden = true
        case .students:
            selectButton.isHidden = false
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
        
        let tapGesture: UITapGestureRecognizer = {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTaps(tap:)))
            return gestureRecognizer
        }()
        nextImageView.addGestureRecognizer(tapGesture)
        
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
    @objc func handleTaps(tap: UITapGestureRecognizer) {
        
        delegate?.proccesTap(tap: tap)
        
    }
    
    @IBAction func selectButtonPressed(_ sender: DesignableButton) {
    
        tbldelegate?.cellHeaderButtonTapped(cell: self)
        
    }
    
 
    
    
}


