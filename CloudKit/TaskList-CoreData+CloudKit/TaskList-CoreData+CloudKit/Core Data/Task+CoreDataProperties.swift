//
//  Task+CoreDataProperties.swift
//  TaskList-CoreData+CloudKit
//
//  Created by Ikmal Azman on 09/03/2022.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var taskName: String?

}

extension Task : Identifiable {

}
