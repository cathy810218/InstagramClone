//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by Cathy Oun on 3/31/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

protocol FeedViewControllerDelegate: class {
    func feedController(didSelect image: UIImage)
}

class FeedViewController: GalleryViewController {
 
    override func updateFeed() {
        CloudKit.shared.getPosts(fromPrivateDatabase: false) { (posts) in
            if let posts = posts {
                self.allPosts = posts.sorted(by: self.sorter)
            }
        }
    }
}
