//
//  ViewController.swift
//  PhotosApp
//
//  Created by Ram Harshvardhan Radhakrishnan on 5/23/16.
//  Copyright © 2016 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var images = [Photos]()
    
    var imageName: String = ""
    
    var imageSelected = UIImage()
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = imageSelected
    }
    
    @IBAction func saveButtonClicked(sender: UIButton) {
        self.saveImageInCoreData(imageView.image!)
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancelButtonClicked(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    //Save images in file path via CoreData
    func saveImageInCoreData(currentImage: UIImage) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Photos", inManagedObjectContext: managedContext)
        let savedImages = Photos(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        let convertedImageToData = UIImagePNGRepresentation(currentImage)
        let randomNumber = arc4random()
        imageName = "\(randomNumber).png"
        let filePath = self.filePathForStoringImages(imageName) //creating a file to store the image in
        convertedImageToData?.writeToFile(filePath as String, atomically: true) //storing the image in the created image file
      
        savedImages.fileName = imageName as String //Assigning value to CoreData attributes
        //savedImages.topic = topic as String //Assigning value to CoreData attributes
        
        do{
            try managedContext.save()
            images.append(savedImages)
        } catch let error as NSError {
            print("Could not save \(error) due to \(error.userInfo)")
        }
    }
    
    //Creating a document path to store images in file path
    func filePathForStoringImages(pathOfImage: String) -> NSString{
        let pathsInArray: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsPath = pathsInArray.objectAtIndex(0) as! NSString
        return documentsPath.stringByAppendingPathComponent(pathOfImage as String)
    }
}

