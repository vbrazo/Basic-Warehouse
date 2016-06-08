//
//  Schema.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/7/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import Foundation
import CoreData

@objc(Warehouse)
class Warehouse: NSManagedObject {
    
    let global = Global()
    let modelHelper = ModelHelper()
    let coreDataStack = CoreDataStack()
        
    func populate_data(){
        self.modelHelper.delete_all("Warehouse") { (response) in
            self.global.request("\(self.global.base_url)/search", params: nil, headers: nil, type: HTTPTYPE.GET) { (response) in
               
                if response.count > 0 {
                    
                    for _ in 0...response.count-1 {
                        
                    }
                        
                    do {
                        try self.coreDataStack.context.save()
                    } catch let error as NSError  {
                        print("Could not save \(error)")
                    }
                }
                
            }
        }
    }
        
    func read_warehouse() -> [Warehouse]? {
            
        let fetchRequest = NSFetchRequest(entityName: "Warehouse")
            
        do {
            let results = try self.coreDataStack.context.executeFetchRequest(fetchRequest) as? [Warehouse]
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
            return nil
        }
            
    }
    
}