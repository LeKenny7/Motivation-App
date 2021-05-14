//
//  EditModel.swift
//  MotivationProject
//
//  Created by kvle2 on 11/25/19.
//  Copyright © 2019 kvle2. All rights reserved.
//

import Foundation
import CoreData
import UIKit
public class EditModel{
    let managedObjectContext:NSManagedObjectContext?
    var fetchResults = [GoalEntity]()
    
    init(context: NSManagedObjectContext)
    {
        managedObjectContext = context
        
        // Getting a handler to the coredata managed object context
    }
    
    func fetchRecord() -> Int {
        // Create a new fetch request using the GoalEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GoalEntity")
        //let sort = NSSortDescriptor(key: "name", ascending: true)
        //fetchRequest.sortDescriptors = [sort]
        var x   = 0
        // Execute the fetch request, and cast the results to an array of GoalEnity objects
        fetchResults = ((try? managedObjectContext!.fetch(fetchRequest)) as? [GoalEntity])!
        x = fetchResults.count
        // return howmany entities in the coreData
        return x
    }
    
    func deleteAllRecords()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GoalEntity")
        
        // whole fetchRequest object is removed from the managed object context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext!.execute(deleteRequest)
            try managedObjectContext!.save()
            
            
        }
        catch let _ as NSError {
            // Handle error
        }
    }
    
}
