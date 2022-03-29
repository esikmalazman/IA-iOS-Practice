//
//  CloudKitManager.swift
//  ToDoList-CloudKit
//
//  Created by Ikmal Azman on 05/03/2022.
//

import Foundation
import CloudKit

enum FetchError {
    case fetchingError, noRecords, none
    case deletingError
    case addingError
    case updatingError
}

// Class that will perform CRUD task to CloudKit
final class CloudKitManager {
    
    // Name of record(table) in container
    private let recordType = "Task"
    // Retrieve the container by its identifier and get public db
    private let publicDatabase = CKContainer(identifier: Constants.CONTAINER_IDENTIFIER).publicCloudDatabase
    
    /// Retrive iCloud logs
    func fetchTasks(completion : @escaping ([CKRecord]?, FetchError)-> Void) {
        
        // Create search that indicate name of table that we create in iCloud
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        // Sort criteria for obtained records e.g. orser based on "createAt" from newest to oldest
        query.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        // Execute the query in public db with query created and selected zone identifier (Default zone, the one we select when create table in iCloud)
        // Return CKRecord, list of records and Error
        publicDatabase.perform(query, inZoneWith: CKRecordZone.default().zoneID) { [weak self] records, error in
            self?.processQueryResponseWith(records: records, error: error as NSError?, completion: { fetchedRecords, fetchError in
                completion(fetchedRecords ?? [], fetchError)
            })
        }
    }
    
    /// Process response from query to db, determine if there is error/any records return and see what these records are
    func processQueryResponseWith(records : [CKRecord]?, error : NSError?, completion : @escaping ([CKRecord]?, FetchError)->Void) {
        
        guard error == nil else {
            completion(nil, .fetchingError)
            return
        }
        
        guard let records = records, records.count > 0 else {
            completion(nil, .noRecords)
            return
        }
        //debugPrint("Success fetched data:  \(records)")
        completion(records, .none)
    }
    
    /// Deleting records from iCloud
    func deleteTasks(_ record : CKRecord, completion : @escaping (FetchError)->Void) {
        
        publicDatabase.delete(withRecordID: record.recordID) { recordID, error in
            
            print("Error deleting records : \(String(describing: error))")
            guard let _ = error else {
                completion(.none)
                return
            }
            completion(.deletingError)
        }
    }
    
    /// Adding new records to iCloud
    func addTasks(_ task : String, completion : @escaping (CKRecord?, FetchError)->Void) {
        let record = CKRecord(recordType: recordType)
        
        record.setObject(task as __CKRecordObjCValue, forKey: "title")
        record.setObject(Date() as __CKRecordObjCValue, forKey: "createdAt")
        record.setObject(0 as __CKRecordObjCValue, forKey: "checked")
        
        publicDatabase.save(record) { record, error in
            print("Error add records : \(String(describing: error))")
            guard let _ = error else {
                completion(record, .none)
                return
            }
            
            completion(nil, .addingError)
        }
    }
    
    /// Update records in iCloud
    func updateTask(_ task : CKRecord, completion : @escaping (CKRecord?, FetchError) -> Void) {
        
        publicDatabase.save(task) { record, error in
            guard let _ = error else {
                completion(record, .none)
                return
            }
            completion(nil, .updatingError)
        }
    }
}
