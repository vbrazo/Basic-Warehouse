//
//  Models.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/11/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON
import CoreData

public class ModelHelper {
    
    var skip = 0
    
    let global = GlobalHelper()
    let coreDataStack = CoreDataStack()
    
    func resetModel(entity: String, completion: (Bool) -> Void) {
        
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
    
    func refresh_models(stock : CurrentlyInStock, txtSearch: String?, completionModels: (Bool) -> Void) {
        
        var params = [String: AnyObject]()
        
        if let text = txtSearch {
            params["q"] = text
        }
        
        params["limit"] = 6        
        params["skip"] = skip
        params["onlyInStock"] = stock.type.rawValue
        
        self.global.request(ROUTES.search, params: params, headers: nil, type: HTTPTYPE.GET) { (response) in
            
            if response.count > 0 {
                for i in 0...response.count-1 {
                    
                    let warehouse = NSEntityDescription.insertNewObjectForEntityForName("Warehouses", inManagedObjectContext: self.coreDataStack.context) as! Warehouse
                    
                    if let info = response[i] {
                        let hash = info[0]
                        
                        warehouse.uid = Int16(self.skip+i)
                        warehouse.face = hash["face"].stringValue
                        warehouse.id = hash["id"].stringValue
                        warehouse.price = hash["price"].floatValue
                        warehouse.size = Int16(hash["size"].intValue)
                        warehouse.stock = Int16(hash["stock"].intValue)
                        
                        if hash["tags"].count > 0 {
                            for j in 0...hash["tags"].count-1 {
                                let tag = NSEntityDescription.insertNewObjectForEntityForName("Tags", inManagedObjectContext: self.coreDataStack.context) as! Tag
                                tag.name = hash["tags"][j]["name"].stringValue
                            }
                        }
                        
                    }
                }
                
                do {
                    try self.coreDataStack.context.save()
                } catch let error as NSError  {
                    print("Could not save \(error)")
                }
                
                completionModels(true)
                
            }
            
        }
    }
}
