//
//  SlideShowViewController.swift
//  PhotosApp
//
//  Created by Ram Harshvardhan Radhakrishnan on 6/2/16.
//  Copyright © 2016 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import UIKit
import AVFoundation

class SlideShowViewController: UIViewController {
    
    var imagesInArray = [UIImage]()

    @IBOutlet weak var slideShowImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Slideshow"
        slideShowImageView.contentMode = .ScaleToFill
        slideShowImageView.animationImages = imagesInArray
        slideShowImageView.animationDuration = 5
        slideShowImageView.animationRepeatCount = 2
        slideShowImageView.startAnimating()
    }
}


