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

public class ServiceManager {
     
    var skip = 0
    
    let global = GlobalHelper()
    let coreDataStack = CoreDataStack()
    
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
                    if let info = response[i] {
                        
                        let hash = info[0]
                        let warehouse = WarehouseService(managedObjectContext: self.coreDataStack.context, coreDataStack: self.coreDataStack)
                        
                        warehouse.addWarehouse(Int16(self.skip+i), face: hash["face"].stringValue, id: hash["id"].stringValue, price: hash["price"].floatValue, size: Int16(hash["size"].intValue), stock: Int16(hash["stock"].intValue), tags: hash["tags"])
            
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
