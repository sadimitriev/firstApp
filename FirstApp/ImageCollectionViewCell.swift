//
//  ImageCollectionViewCell.swift
//  FirstApp
//
//  Created by Sergey Dimitriev on 30/05/2019.
//  Copyright © 2019 Sergey Dimitriev. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ImageField: UIImageView!
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var contentField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleField.numberOfLines = 0
        titleField.lineBreakMode = .byWordWrapping
        titleField.sizeToFit()
        
        contentField.numberOfLines = 0
        contentField.lineBreakMode = .byWordWrapping
        contentField.sizeToFit()
        
        
    }
}
