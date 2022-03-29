//
//  Task+CoreDataClass.swift
//  TaskList-CoreData+CloudKit
//
//  Created by Ikmal Azman on 09/03/2022.
//
//

import Foundation
import CoreData


public class Task: NSManagedObject {
    /// Allow to fetch all data and return an Array of Task type
    static func fetchAll(viewContext : NSManagedObjectContext = AppDelegate.viewContext) -> [Task] {
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "taskName", ascending: true)]
        
        guard let tasks = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        
        return tasks
    }
    /// Allow to delete all tasks in persistent container
    static func deleteAll(viewContext : NSManagedObjectContext = AppDelegate.viewContext) {
        let allTasks = Task.fetchAll()
        
        allTasks.forEach { task in
            viewContext.delete(task)
        }
        
        try? viewContext.save()
    }
}

/// Step to delete a task in persistent store
/// 1. Fetch task need to delete
/// 2. Delete task
/// 3. Save changes in context
