//
//  PhotosViewController.swift
//  PhotosApp
//
//  Created by Ram Harshvardhan Radhakrishnan on 5/30/16.
//  Copyright © 2016 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 8.0, *)
class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate {

    let picker = UIImagePickerController()
    
    //let imageViewController = ViewController()
    
    //let listViewController = ListViewController()
    
    var savedImagesInCoreData = [Photos]()
    
    var imageTopic: String = ""
    
    var imageDisplay = UIImage()
    
    var imagesInSlideShow = [UIImage]()
    
    var imageInDataFormat = NSData() //Photos - CoreData
    
    var imageFromData = UIImage() //Photos - CoreData
    
    @IBOutlet weak var imagesTableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    
    @IBAction func cameraButtonClicked(sender: UIButton) {
        picker.sourceType = .Camera
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func photosButtonClicked(sender: UIButton) {
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func slideShowButtonClicked(sender: UIButton) {
        self.imagesTableView.reloadData()
        self.performSegueWithIdentifier("slideShowSegue", sender: self) //Preparing segue to SlideShowViewController class
    }
    
    //show the image once it has been selected
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageDisplay = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        self.performSegueWithIdentifier("viewControllerSegue", sender: self) //Preparing segue to ViewController class
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        return savedImagesInCoreData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "Cell"
        let cell = self.imagesTableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomCell
        let photo = savedImagesInCoreData[indexPath.row]
      
        let filePath = ViewController().filePathForStoringImages(photo.fileName!)
        imageFromData = UIImage(contentsOfFile: filePath as String)!
        let scaledImage = scaleSizeOfImage(imageFromData, size: CGSize(width: 150, height: 150)) //same width and height of imageView from StoryBoard
        cell.imageViewInCell.frame = CGRectMake(0, 0, 150, 150)
        cell.imageViewInCell.contentMode = .ScaleAspectFit
        
        cell.imageViewInCell.image = scaledImage 
        
        imagesInSlideShow.append(imageFromData)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let photo = savedImagesInCoreData[(indexPath.row)]
        let filePath = ViewController().filePathForStoringImages(photo.fileName!)
        imageInDataFormat = NSData(contentsOfFile: filePath as String)!
       // imageTopic = photo.topic!
        self.performSegueWithIdentifier("displaySegue", sender: self) //Preparing segue to DisplayViewController class
    }

    //Resizing the image in the thumbnail in cell by creating a canvas of desired image size with input image and image size
    func scaleSizeOfImage(image:UIImage, size:CGSize) -> UIImage { //CGSize is width X height
        UIGraphicsBeginImageContext(size) //creates a canvas wherein the rectangle will be drawn
        image.drawInRect(CGRect(origin: CGPointZero, size: size)) //rectangle with starting point as origin and size as input parameter
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext() //to save memory
        return newImage
    }
    
    //Deleting data from a row
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            managedContext.deleteObject(savedImagesInCoreData[indexPath.row] as NSManagedObject)
            savedImagesInCoreData.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "displaySegue") {
            let displayVC = segue.destinationViewController as! DisplayViewController
            displayVC.imageReceived = imageInDataFormat
            displayVC.dateText = imageTopic
        }
        if (segue.identifier == "viewControllerSegue") {
            let vc = segue.destinationViewController as! ViewController
            vc.imageSelected = imageDisplay
        }
        if (segue.identifier == "slideShowSegue") {
            let slideShowVC = segue.destinationViewController as! SlideShowViewController
            slideShowVC.imagesInArray = imagesInSlideShow
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
//        if let imageTableView = self.imagesTableView {
//            imageTableView.reloadData()
//        }
        
        self.imagesTableView?.reloadData() //Optional added since initially imagesTableView is nil
        self.imagesTableView?.delegate = self
        self.imagesTableView?.dataSource = self
        title = "Saved Photos"
       //self.imagesTableView.registerClass(CustomCell.self, forCellReuseIdentifier: "Cell")
    }
    
    //Fetching data from saved CoreData stack
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        getFetchedResultsControllerForImages()
        
        savedImagesInCoreData = self.fetchedResultsController.fetchedObjects as! [Photos]
        
        
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        let fetchRequest = NSFetchRequest(entityName: "Photos")
//        
//       // fetchRequest.predicate = NSPredicate(format: "topic == %@", "GYM")
//        
//        do{
//            let results = try managedContext.executeFetchRequest(fetchRequest)
//            savedImagesInCoreData = results as! [Photos]
//        } catch let error as NSError {
//            print("Could not fetch \(error), due to \(error.userInfo)")
//        }
        
        self.imagesTableView?.reloadData()
    }
    
    
    
    func getFetchedResultsControllerForImages() -> NSFetchedResultsController {
    
    let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest()
    
    //3 - set the correct table
    let entity = NSEntityDescription.entityForName("Photos", inManagedObjectContext: managedObjectContext)
    fetchRequest.entity = entity
    
    fetchRequest.fetchBatchSize = 20
        
        

//    //Equal to "WHERE" query in SQL
//    let predicate = NSPredicate(format: "topic = %@", "topic")
//        fetchRequest.predicate = predicate
//    
//        
        
        
    
    let sectionSortDescriptor = NSSortDescriptor(key: "fileName", ascending: true)
    
    let sortDescriptors = [sectionSortDescriptor]
    
    fetchRequest.sortDescriptors = sortDescriptors
        
        
        
    
    
    do {
    
    let aFetchedResultsController = NSFetchedResultsController (fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "fileName", cacheName: nil)
    
    aFetchedResultsController.delegate = self
    self.fetchedResultsController = aFetchedResultsController
    
    try self.fetchedResultsController.performFetch()
    
    } catch let error as NSError {
    print("Could not fetch \(error), due to \(error.userInfo)")
    }
    
    return self.fetchedResultsController
    
    }
    
    
}










