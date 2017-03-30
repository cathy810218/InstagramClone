//
//  GalleryCollectionViewCell.swift
//  InstagramClone
//
//  Created by Cathy Oun on 3/29/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var post: Post! {
        didSet {
            self.imageView.image = post.image
            let dateString = DateFormatter.localizedString(from: post.date,
                                                           dateStyle: .long,
                                                           timeStyle: .short)
            self.dateLabel.text = dateString
        }
    }
    
    override func prepareForReuse() {
        // every collection view has
        super.prepareForReuse()
        
        // first nil out the image
        self.imageView.image = nil
        
        
    }
}
