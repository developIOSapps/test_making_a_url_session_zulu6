//
//  TableViewCell.swift
//  Template Categories
//
//  Created by Steven Hertz on 2/7/20.
//  Copyright © 2020 DevelopItSolutions. All rights reserved.
//

import UIKit

protocol AppTableViewDelegate {
    func cellRowButtonTapped(cell: AppTableViewCell)
    func cellHeaderButtonTapped(cell: HeaderTableViewCell)
}

class AppTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var selectButton: DesignableButton!
    
    var delegate: AppTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func selectButtonPressed(_ sender: DesignableButton) {
    
        delegate?.cellRowButtonTapped(cell: self)
        
    }
}
