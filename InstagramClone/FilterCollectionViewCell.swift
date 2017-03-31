//
//  FilterCollectionViewCell.swift
//  InstagramClone
//
//  Created by Cathy Oun on 3/30/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!
    
    override func prepareForReuse() {
        // every collection view has
        super.prepareForReuse()
        
        // first nil out the image
        self.filterImageView.image = nil
    }
}
