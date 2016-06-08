//
//  Models.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/8/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import CoreData
import Foundation

struct ModelHelper {
    
    let coreDataStack = CoreDataStack()
    
    func delete_all(entity: String, completion: (Bool) -> Void) {
        
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let results = try coreDataStack.context.executeFetchRequest(fetchRequest)
            
            if (results.count>0) {
                
                for obj in results {
                    let objData : NSManagedObject = obj as! NSManagedObject
                    coreDataStack.context.deleteObject(objData)
                }
                
                var context : NSManagedObjectContext!
                
                context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
                context.persistentStoreCoordinator = coreDataStack.context.persistentStoreCoordinator
                
                if self.coreDataStack.context.hasChanges {
                    do {
                        try self.coreDataStack.context.save()
                    } catch {
                        let nserror = error as NSError
                        print("Error: \(nserror.localizedDescription)")
                        abort()
                    }
                }
                
            }
            
            completion(true)
            
        } catch let error as NSError {
            print("Delete all - error : \(error) \(error.userInfo)")
        }
        
    }
    
}