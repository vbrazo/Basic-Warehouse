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
    
    //
    // refresh model and populate it again
    //
    func refresh_model(){
        self.modelHelper.delete_all("Warehouse") { (response) in
            self.global.request(ROUTES.search, params: nil, headers: nil, type: HTTPTYPE.GET) { (response) in
               
                if response.count > 0 {
                    
                    for _ in 0...response.count-1 {
                        let warehouse = NSEntityDescription.insertNewObjectForEntityForName("Warehouse", inManagedObjectContext: self.coreDataStack.context) as! Warehouse
                        warehouse.face = ""
                        warehouse.id = Int16("")!
                        warehouse.price = Float("")!
                        warehouse.size = Int16("")!
                        warehouse.stock = Int16("")!
                        warehouse.type = ""
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
        
}