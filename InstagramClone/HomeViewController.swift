//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Cathy Oun on 3/27/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    // constraints
    @IBOutlet weak var postButtonVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterButtonVerticalConstraint: NSLayoutConstraint!
    
    let imagePicker = UIImagePickerController()
    var originalImage: UIImage?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postButtonVerticalConstraint.constant = 8
        filterButtonVerticalConstraint.constant = 15
        
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
    }

    @IBAction func postButtonPressed(_ sender: Any) {
        if let image = self.imageView.image {
            // if there's an image inside the imageView
            
            // create a post object
            let newPost = Post(image: image, date: Date())
            
            CloudKit.shared.save(post: newPost, completion: { (success) in
                if success {
                    print("Success")
                } else {
                    print("Error saving")
                }
            })
        }
    }

    @IBAction func filterButtonPressed(_ sender: Any) {
        guard let image = self.originalImage else {
            return
        }
        
        let alertController = UIAlertController(title: "Filter", message: "Please select a filter", preferredStyle:.alert)
        
        let blackAndWhiteAction = UIAlertAction(title: "Black and White", style: .default) { (action ) in
            Filters.filter(name: .blackAndWhite, image: image, completion: {(filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        let vintageAction = UIAlertAction(title: "Vintage", style: .default) { (action) in
            Filters.filter(name: .vintage, image: image, completion: {(filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        let sepiaAction = UIAlertAction(title: "Sepia", style: .default) { (action) in
            Filters.filter(name: .sepia, image: image, completion: {(filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        let colorInvertAction = UIAlertAction(title: "Invert", style: .default) { (action) in
            Filters.filter(name: .colorInvert, image: image, completion: {(filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        let colorPosterizeAction = UIAlertAction(title: "Polarize", style: .default) { (action) in
            Filters.filter(name: .colorPosterize, image: image, completion: {(filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        let resetAction = UIAlertAction(title: "Reset Image", style: .destructive) {(action) in
            self.imageView.image = self.originalImage
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alertController.addAction(blackAndWhiteAction)
        alertController.addAction(vintageAction)
        alertController.addAction(sepiaAction)
        alertController.addAction(colorInvertAction)
        alertController.addAction(colorPosterizeAction)
        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func tapGesture(_ sender: Any) {
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            originalImage = image
            imagePicker.dismiss(animated: true) {
                UIView.transition(with: self.imageView, duration: 1, options: .transitionCrossDissolve, animations: {
                    self.imageView.image = image
                }, completion: nil)
            }
        } else{
            print("Something went wrong")
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

}

