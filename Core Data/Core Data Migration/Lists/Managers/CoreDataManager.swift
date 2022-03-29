//
//  CoreDataManager.swift
//  Lists
//
//  Created by Bart Jacobs on 07/03/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//  https://cocoacasts.com/migrating-a-data-model-with-core-data

import CoreData

final class CoreDataManager {
    
    // MARK: - Properties
    
    private let modelName: String
    
    // MARK: - Initialization
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - Core Data Stack
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            
            // Adding lightweight migration supports in dictionary options with 2 keys
            // NSInferMappingModelAutomaticallyOption : true, Allow CoreData to understand mapping model for migration bas data model versions of data model
            // NSMigratePersistentStoresAutomaticallyOption : true, Allow to tell CoreData to automatic perform migration if detect incompatibility
            
            // Mapping model, define how one version of data model relates to another version
            // Ligthweight migration, CoreData can understand mapping model by inspect the data model version
            // Heavyweight migration, it is complex, dev need t create own mapping model
            let options = [NSInferMappingModelAutomaticallyOption : true, NSMigratePersistentStoresAutomaticallyOption:true]
            
            // addPersistentStore, allow to add specified type of persistent store at particular location
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
}
