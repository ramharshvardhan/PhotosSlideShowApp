//
//  ListViewController.swift
//  PhotosApp
//
//  Created by Ram Harshvardhan Radhakrishnan on 6/9/16.
//  Copyright © 2016 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 8.0, *)
class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var savedTopicsInCoreData = [Group]()
    
    //var photosViewController = PhotosViewController()
    
    //let imageViewController = ViewController()
    
    var imageNamePassed = String()
    
    var groupName = String()
    
    @IBOutlet weak var listTableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
  
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
//        let count = self.fetchedResultsController.sections?.count ?? 0
//        
//        return count
        
        
        return 1
    }
    
    
    @IBAction func addGroupName(sender: UIBarButtonItem) {
        
    
        let alertView = UIAlertController(title: "New Group", message: "Add a group name", preferredStyle: UIAlertControllerStyle.Alert)
    
        
          //  alertView.addTextFieldWithConfigurationHandler(addTextField)
        
        
        alertView.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        
            alertView.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Enter a new group name"
        }
        
        alertView.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) in
            
            if let textFieldsArray = alertView.textFields {
                
                let textFields = textFieldsArray 
                self.groupName = textFields[0].text!
                
                self.saveTopicInCoreData(self.groupName)
                
            }
            
          //  self.listTableView.reloadData()
            
            
        }))
        
        
        self.presentViewController(alertView, animated: true, completion: nil)
    
        
    }
    
    
    func saveTopicInCoreData(groupName: NSString) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Group", inManagedObjectContext: managedContext)
        let savedTopics = Group(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        
        savedTopics.topic = groupName as String
        
        
        do{
            try managedContext.save()
            savedTopicsInCoreData.append(savedTopics)
        } catch let error as NSError {
            print("Could not save \(error) due to \(error.userInfo)")
        }
        
    }
  
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return savedTopicsInCoreData.count
        
       // return (self.fetchedResultsController.sections?.count)!
        
//        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
//        return sectionInfo.numberOfObjects
        
        //return savedImagesInCoreData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "ListCell"
        let cell = self.listTableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ListTableViewCell
        let topics = savedTopicsInCoreData[indexPath.row]
    
        
        cell.listTextView.text = topics.topic

//        cell.doneButton.tag = indexPath.row
//        cell.doneButton.addTarget(self, action: Selector("handelActionForDoneButton:"), forControlEvents: .TouchUpInside)
        
        
        //Implement the below change
        
//        //Update tableview once data is added/changed in table view
//        if let listTableView = self.listTableView {
//            
//            listTableView.reloadData()
//        }
    
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //navigationController?.pushViewController(PhotosViewController(), animated: true)
        
        //self.presentViewController(PhotosViewController(), animated: true, completion: nil)
        
//        let topics = savedTopicsInCoreData[(indexPath.row)]
//        imageNamePassed = topics.fileName!
        
        
        self.performSegueWithIdentifier("showImages", sender: self)
    }
    
    
    //PrepareForSegue used when destination screen is black
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showImages") {
         
            
            //Get rid of this below warning
            
            let showImagesVC = segue.destinationViewController as! PhotosViewController
            //showImagesVC.imageTopic = imageNamePassed
            
        }

    }
    

    //Deleting data from a row
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            managedContext.deleteObject(savedTopicsInCoreData[indexPath.row] as NSManagedObject)
            savedTopicsInCoreData.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.reloadData()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        
    }
    
    //Fetching data from saved CoreData stack
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        
        getFetchedResultController()
        
        savedTopicsInCoreData = self.fetchedResultsController.fetchedObjects as! [Group]
        
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        let fetchRequest = NSFetchRequest(entityName: "Photos")
//        
//        let predicate = NSPredicate(format: "attribute == %@", "topic")
//        fetchRequest.predicate = predicate
//        
//        do{
//            let results = try managedContext.executeFetchRequest(fetchRequest)
//            savedImagesInCoreData = results as! [Photos]
//        } catch let error as NSError {
//            print("Could not fetch \(error), due to \(error.userInfo)")
//        }
        
        
        self.listTableView.reloadData()
        
        
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest()
        
        //3 - set the correct table
        let entity = NSEntityDescription.entityForName("Group", inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entity
    
        fetchRequest.fetchBatchSize = 20
    
        
//        let predicate = NSPredicate(format: "topic == %@", "topic")
//        fetchRequest.predicate = predicate
//        
        
        let sectionSortDescriptor = NSSortDescriptor(key: "topic", ascending: true)
        
        let sortDescriptors = [sectionSortDescriptor]
        
        fetchRequest.sortDescriptors = sortDescriptors
        
        
        do {
            
            let aFetchedResultsController = NSFetchedResultsController (fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "topic", cacheName: nil)
            
            aFetchedResultsController.delegate = self
            self.fetchedResultsController = aFetchedResultsController
            
            try self.fetchedResultsController.performFetch()
        
        } catch let error as NSError {
            print("Could not fetch \(error), due to \(error.userInfo)")
        }
        
        return self.fetchedResultsController
        
    }

}
