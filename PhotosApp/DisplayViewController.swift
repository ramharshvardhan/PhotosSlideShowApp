//
//  DisplayViewController.swift
//  PhotosApp
//
//  Created by Ram Harshvardhan Radhakrishnan on 5/24/16.
//  Copyright © 2016 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import UIKit
import AVFoundation

class DisplayViewController: UIViewController {

    var imageReceived = NSData()
    
    var dateText: String = ""
    
    @IBOutlet weak var imageDisplay: UIImageView!
    
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBAction func backButtonClicked(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Display Image"
        
        let imageConverted = UIImage(data: imageReceived)
        let orientedImage = UIImage(CGImage: imageConverted!.CGImage!, scale: 1, orientation: imageConverted!.imageOrientation) //Setting the image orientation as the same as it was taken
        let rect = AVMakeRectWithAspectRatioInsideRect((imageConverted?.size)!, imageDisplay.bounds) //Maintaining the original aspect ratio of the saved image
        //let rectInImage = CGImageCreateWithImageInRect(imageConverted!.CGImage, rect)
        imageDisplay.frame = rect
        imageDisplay.contentMode = .ScaleAspectFill //Changing the aspect ratio
        imageDisplay.image = orientedImage
        imageLabel.text = "Created on " + dateText
    }
}
