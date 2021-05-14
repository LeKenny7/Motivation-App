//
//  GoalEntity+CoreDataProperties.swift
//  MotivationProject
//
//  Created by kvle2 on 11/24/19.
//  Copyright © 2019 kvle2. All rights reserved.
//
//

import Foundation
import CoreData


extension GoalEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalEntity> {
        return NSFetchRequest<GoalEntity>(entityName: "GoalEntity")
    }

    @NSManaged public var detail: String?
    @NSManaged public var name: String?
    @NSManaged public var picture: NSData?

}
