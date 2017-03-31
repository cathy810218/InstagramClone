//
//  GalleryViewController.swift
//  InstagramClone
//
//  Created by Cathy Oun on 3/29/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

protocol GalleryViewControllerDelegate: class {
    func galleryController(didSelect image: UIImage)
}

class GalleryViewController: UIViewController {

    weak var delegate: GalleryViewControllerDelegate?
    
    @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
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

    @IBAction func userPinched(_ sender: UIPinchGestureRecognizer) {
        guard let layout = collectionView.collectionViewLayout as? GalleryCollectionViewLayout else {
            return
        }
        switch sender.state {
        case .began:
            print("Start pinching")
            break
        case .changed:
            break
        case .ended:
            print("end pinching")
            let columns = sender.velocity > 0 ? layout.columns - 1 : layout.columns + 1
            if columns < 1 || columns > 4 { return }
             collectionView.setCollectionViewLayout(GalleryCollectionViewLayout(columns: columns), animated: true)
            
        default:
            break
        }
    }
}

// Mark: UICollectionView
extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as! GalleryCollectionViewCell
        cell.post = allPosts[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.delegate else { return }
        
        let selectedPost = self.allPosts[indexPath.row]
        delegate.galleryController(didSelect: selectedPost.image)
    }
}


