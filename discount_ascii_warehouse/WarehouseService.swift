//
//  WarehouseService.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/11/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import CoreData
import SwiftyJSON

public class WarehouseService: MainService {
       
    public func add(uid: Int16, face: String, id: String, price: Float, size: Int16, stock: Int16, tags: JSON) -> Warehouse? {
        
        let warehouse = NSEntityDescription.insertNewObjectForEntityForName("Warehouses", inManagedObjectContext: self.context) as! Warehouse
        
        warehouse.uid = uid
        warehouse.face = face
        warehouse.id = id
        warehouse.price = price
        warehouse.size = size
        warehouse.stock = stock
        
        let tagService = TagService(context: self.context, coreDataStack: self.coreDataStack)
        
        if tags.count > 0 {
            for j in 0...tags.count-1 {
                tagService.add(tags[j].stringValue, warehouse: warehouse)
            }
        }
        
        self.coreDataStack.saveContext(self.context)
        
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
                        self.add(Int16(skip+i),
                                 face: hash["face"].stringValue,
                                 id: hash["id"].stringValue,
                                 price: hash["price"].floatValue,
                                 size: Int16(hash["size"].intValue),
                                 stock: Int16(hash["stock"].intValue),
                                 tags: hash["tags"])
                    }
                }
                
                do {
                    try self.context.save()
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