//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Cathy Oun on 3/27/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit
import Social

class HomeViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // constraints
    @IBOutlet weak var filterCollectionViewHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postButtonVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterButtonVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var publicPostButtonVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterCollectionViewHightConstraint.constant = 0
        publicPostButtonVerticalConstraint.constant = -80
        postButtonVerticalConstraint.constant = -80
        imageViewYConstraint.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postButtonVerticalConstraint.constant = 15
        filterButtonVerticalConstraint.constant = 8
        publicPostButtonVerticalConstraint.constant = 15
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        collectionView.dataSource = self
        collectionView.delegate = self
        imagePicker.delegate = self
        setupGalleryDelegate()
        
    }
    
    func setupGalleryDelegate() {
        if let tabBarController = self.tabBarController {
            guard let viewControllers = tabBarController.viewControllers else { return }
            guard let galleryController = viewControllers[1] as? GalleryViewController else { return }
            
            galleryController.delegate = self
        }
    }
    
    @IBAction func publicPostButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        if let image = self.imageView.image {
            // if there's an image inside the imageView
            
            // create a post object
            let newPost = Post(image: image, date: Date())
            
            CloudKit.shared.save(post: newPost, toPrivateDatabase: false, completion: { (success) in
                let alert = success ? UIAlertController(title: "Successfully Uploaded", message: "Now go to Public feed to check out your new post.", preferredStyle: .alert) : UIAlertController(title: "Oh No!", message: "Something is wrong! Please make sure that you're logged in to iCloud on your device.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: { 
                    self.activityIndicator.stopAnimating()
                })
            })
        }
    }
    
    
    @IBAction func postButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        if let image = self.imageView.image {
            // if there's an image inside the imageView
            
            // create a post object
            let newPost = Post(image: image, date: Date())
            
            CloudKit.shared.save(post: newPost, toPrivateDatabase: true, completion: { (success) in
                let alert = success ? UIAlertController(title: "Successfully Uploaded", message: "Now go to Private feed to check out your new post.", preferredStyle: .alert) : UIAlertController(title: "Oh No!", message: "Something is wrong! Please make sure that you're logged in to iCloud on your device.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: {
                    self.activityIndicator.stopAnimating()
                })
            })
        }
    }
    
    
    func showOrHideFilterCollection() {
        if filterCollectionViewHightConstraint.constant == 150 {
            // is shown, hide it
            filterCollectionViewHightConstraint.constant = 0
            imageViewYConstraint.constant = 0
        } else {
            filterCollectionViewHightConstraint.constant = 150
            imageViewYConstraint.constant = -90
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        guard let _ = Filters.originalImage else {
            return
        }
        showOrHideFilterCollection()
    }
    
    //MARK: UIGestureRecognizer
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Choose your photo",
                                      message: "",
                                      preferredStyle: .actionSheet)
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = view
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive,
                                         handler: nil)
        let photosAction = UIAlertAction(title: "Photos", style: .default) { (action) in
            // show imagePicker
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(cameraAction)
        }
        alert.addAction(photosAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func longPressed(_ sender: UILongPressGestureRecognizer) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            guard let composeController = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else {
                return
            }
            // Put your share data to compose controller
            composeController.add(imageView.image)
            present(composeController, animated: true, completion: nil)
        }
    }
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as! FilterCollectionViewCell
        
        guard let originalImage = Filters.originalImage else {
            return filterCell
        }
        guard let resizedImage = originalImage.resize(size: CGSize(width: 150, height: 150)) else { return filterCell }
        
        let filterName = FilterType.allFilters[indexPath.row]
        filterCell.filterNameLabel.text = FilterType.allFiltersString[indexPath.row]
        
        Filters.filter(name: filterName, image: resizedImage) { (filteredImage) in
            filterCell.filterImageView.image = filteredImage
        }
        
        return filterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FilterType.allFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFilterName = FilterType.allFilters[indexPath.row]
        guard let selectedImage = Filters.originalImage else { return }
        Filters.filter(name: selectedFilterName, image: selectedImage) { (filteredImage) in
            self.imageView.image = filteredImage
        }
    }
}

extension HomeViewController: GalleryViewControllerDelegate {
    func galleryController(didSelect image: UIImage) {
        self.imageView.image = image
        Filters.originalImage = image
        self.tabBarController?.selectedIndex = 0
    }
}

extension HomeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            Filters.originalImage = image
            imagePicker.dismiss(animated: true) {
                UIView.transition(with: self.imageView, duration: 1, options: .transitionCrossDissolve, animations: {
                    self.imageView.image = image
                }, completion: nil)
            }
        } else{
            print("Something went wrong")
        }
        collectionView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
