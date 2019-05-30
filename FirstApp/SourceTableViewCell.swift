//
//  SourceTableViewCell.swift
//  FirstApp
//
//  Created by Sergey Dimitriev on 29/05/2019.
//  Copyright © 2019 Sergey Dimitriev. All rights reserved.
//

import UIKit

class SourceTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDetail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellTitle.numberOfLines = 0
        cellTitle.lineBreakMode = .byWordWrapping
        cellTitle.sizeToFit()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
