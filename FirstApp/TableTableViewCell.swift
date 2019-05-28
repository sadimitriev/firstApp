//
//  TableTableViewCell.swift
//  FirstApp
//
//  Created by Sergey Dimitriev on 19/05/2019.
//  Copyright © 2019 Sergey Dimitriev. All rights reserved.
//

import UIKit

class TableTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var celldate: UILabel!
    @IBOutlet weak var cellTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellTitle.numberOfLines = 0
        cellTitle.lineBreakMode = .byWordWrapping
        cellTitle.sizeToFit()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
