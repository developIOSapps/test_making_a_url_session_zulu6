//
//  TableViewCell.swift
//  Template Categories
//
//  Created by Steven Hertz on 2/7/20.
//  Copyright © 2020 DevelopItSolutions. All rights reserved.
//

import UIKit

class AppTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var subtitle: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
