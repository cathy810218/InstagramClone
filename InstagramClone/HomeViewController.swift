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

