//
//  WarehouseService.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/11/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import CoreData
import Foundation
import SwiftyJSON

public class WarehouseService {
   
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
    
    public func addWarehouse(uid: Int16, face: String, id: String, price: Float, size: Int16, stock: Int16, tags: JSON) -> Warehouse? {
        
        let warehouse = NSEntityDescription.insertNewObjectForEntityForName("Warehouses", inManagedObjectContext: managedObjectContext) as! Warehouse
        
        warehouse.uid = uid
        warehouse.face = face
        warehouse.id = id
        warehouse.price = price
        warehouse.size = size
        warehouse.stock = stock
        
        if tags.count > 0 {
            for j in 0...tags.count-1 {
                let tag = NSEntityDescription.insertNewObjectForEntityForName("Tags", inManagedObjectContext: self.coreDataStack.context) as! Tag
                tag.name = tags[j].stringValue
                warehouse.tag.insert(tag)
            }
        }
        
        coreDataStack.saveContext()
        
        return warehouse
        
    }
    
    public func resetModel(entity: String, completion: (Bool) -> Void) {
        
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
                        completion(false)
                    }
                }
                
            }
            
            completion(true)
            
        } catch let error as NSError {
            print("Delete all - error : \(error) \(error.userInfo)")
        }
        
    }
    
}