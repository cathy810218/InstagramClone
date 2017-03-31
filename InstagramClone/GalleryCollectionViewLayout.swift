//
//  GalleryCollectionViewLayout.swift
//  InstagramClone
//
//  Created by Cathy Oun on 3/29/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

class GalleryCollectionViewLayout: UICollectionViewFlowLayout {
    
    var columns = 2
    let spacing: CGFloat = 1.0
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var itemWidth: CGFloat {
        let availableScreenWidth = screenWidth - (CGFloat((columns - 1)) * spacing)
        return availableScreenWidth / CGFloat(self.columns)
    }
    
    init(columns: Int = 2) {
        // designated initializer
        // start initializing the variables that we created ^
        self.columns = columns
        
        // initialize the parent using super and we can modify parent members
        super.init()
        
        self.minimumLineSpacing = 30 // horizontal distance
        self.minimumInteritemSpacing = spacing // vertical distance
        self.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
