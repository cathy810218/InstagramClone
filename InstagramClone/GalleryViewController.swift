//
//  GalleryViewController.swift
//  InstagramClone
//
//  Created by Cathy Oun on 3/29/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var allPosts = [Post]() {
        // property observer
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = GalleryCollectionViewLayout(columns: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }
    
    func update() {
        CloudKit.shared.getPosts { (posts) in
            if let posts = posts {
                self.allPosts = posts.sorted(by: self.sorter)
            }
        }
    }
    
    func sorter(this: Post, that: Post) -> Bool {
        return this.date > that.date
    }

}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifer, for: indexPath) as! GalleryCollectionViewCell
        cell.post = allPosts[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
}


