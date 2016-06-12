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
   
    private let global = GlobalHelper()
    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext
    
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = managedObjectContext
    }
    
    public func add(uid: Int16, face: String, id: String, price: Float, size: Int16, stock: Int16, tags: JSON) -> Warehouse? {
        
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
        
        self.coreDataStack.saveContext()
        
        return warehouse
        
    }
    
    public func refresh(stock: CurrentlyInStock, txtSearch: String?, skip: Int, completionModels: (Bool) -> Void) {
        
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
                    if let info = response[i] {
                        
                        let hash = info[0]
                        let warehouse = WarehouseService(managedObjectContext: self.coreDataStack.context, coreDataStack: self.coreDataStack)
                        
                        warehouse.add(Int16(skip+i), face: hash["face"].stringValue, id: hash["id"].stringValue, price: hash["price"].floatValue, size: Int16(hash["size"].intValue), stock: Int16(hash["stock"].intValue), tags: hash["tags"])
                        
                    }
                }
                
                do {
                    try self.coreDataStack.context.save()
                } catch let error as NSError  {
                    print("Could not save \(error)")
                }
                
                completionModels(true)
                
            } else {
                completionModels(false)
            }
            
        }
    }
    
}