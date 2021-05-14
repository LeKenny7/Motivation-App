//
//  EditGoalsTableViewController.swift
//  MotivationProject
//
//  Created by kvle2 on 11/22/19.
//  Copyright © 2019 kvle2. All rights reserved.
//

import UIKit
import CoreData

class EditGoalsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate , UINavigationControllerDelegate  {

    @IBOutlet weak var goalTable: UITableView!
    
    let picker = UIImagePickerController()
    
    // handler to the managege object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var em:EditModel?
    
    //this is the array to store Goal entities from the coredata
    var fetchResults = [GoalEntity]()
    
    func fetchRecord() -> Int {
        // Create a new fetch request using the GoalEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GoalEntity")
        //let sort = NSSortDescriptor(key: "name", ascending: true)
        //fetchRequest.sortDescriptors = [sort]
        var x   = 0
        // Execute the fetch request, and cast the results to an array of GoalEnity objects
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [GoalEntity])!
        x = fetchResults.count
        // return howmany entities in the coreData
        return x
    }
    
    override func viewDidLoad() {
        em = EditModel(context: managedObjectContext)
        self.goalTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // number of rows based on the coredata storage
        return fetchRecord()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // add each row from coredata fetch results
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.layer.borderWidth = 1.0
        cell.textLabel?.text = fetchResults[indexPath.row].name
        cell.detailTextLabel?.text = fetchResults[indexPath.row].detail
        
        if let picture = fetchResults[indexPath.row].picture {
            cell.imageView?.image =  UIImage(data: picture  as Data)
        }
        else {
            cell.imageView?.image = nil
        }
        return cell
    }
    
    // delete table entry
    // this method makes each row editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    // return the table view style as deletable
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell.EditingStyle { return UITableViewCell.EditingStyle.delete }
    
    
    // implement delete function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            managedObjectContext.delete(fetchResults[indexPath.row])
            fetchResults.remove(at:indexPath.row)
            do {
                try managedObjectContext.save()
            } catch {
            }
            goalTable.reloadData()
        }
    }
    
    @IBAction func addARecord(_ sender: UIBarButtonItem) {
        if em!.fetchRecord() >= 6
        {
            let alert = UIAlertController(title: "whoops!", message: "Can only have 6 goals", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // show the alert controller to select an image for the row
        let alertController = UIAlertController(title: "Add Goal", message: "", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in textField.placeholder = "Enter your goal" })
        alertController.addTextField(configurationHandler: { textField in textField.placeholder = "Enter your description" })
        
        let searchAction = UIAlertAction(title: "Add Picture", style: .default) { (action) in
            // load image
            if let name = alertController.textFields?.first?.text{
                let ent = NSEntityDescription.entity(forEntityName: "GoalEntity", in: self.managedObjectContext)
                //add to the manege object context
                let newItem = GoalEntity(entity: ent!, insertInto: self.managedObjectContext)
                newItem.name = name
                if let detail = alertController.textFields![1].text{
                    newItem.detail = detail
                }
                newItem.picture = nil
                let photoPicker = UIImagePickerController ()
                photoPicker.delegate = self
                photoPicker.sourceType = .photoLibrary
                // display image selection view
                self.present(photoPicker, animated: true, completion: nil)
                do {
                    try self.managedObjectContext.save()
                } catch _ {
                }
                self.goalTable.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        // save the updated context
        do {
            try self.managedObjectContext.save()
        } catch _ {
        }
    }
      
    @IBAction func deleteAll(_ sender: UIBarButtonItem) {
        em?.deleteAllRecords()
        goalTable.reloadData()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker .dismiss(animated: true, completion: nil)
        // fetch result set has the recently added row without the image
        // this code adds the image to the row
        
        if let goal = fetchResults.last, let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            goal.picture = image.pngData()! as NSData
            
            do { try managedObjectContext.save() }
            catch { print("Error while saving the new image") }
            goalTable.reloadData()
        }
    }
    
    @IBAction func pictureButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            print("No camera")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailView"){
            let selectedIndex: IndexPath = self.goalTable.indexPath(for: sender as! UITableViewCell)!
            let currentGoal = fetchResults[selectedIndex.row]
            if let viewController: DetailEditViewController = segue.destination as? DetailEditViewController {
                viewController.selectedGoal = currentGoal.name
                viewController.selectedDetail = currentGoal.detail
                viewController.selectedImage = UIImage(data: currentGoal.picture! as Data)
            }
        }
    }
}

