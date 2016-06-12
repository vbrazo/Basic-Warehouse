//
//  TagService.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/12/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import CoreData
import SwiftyJSON

public class TagService {
    
    private let global = GlobalHelper()
    private let coreDataStack: CoreDataStack
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.context = context
    }
    
    public func add(name: String, warehouse: Warehouse) {
        let tag = NSEntityDescription.insertNewObjectForEntityForName("Tags", inManagedObjectContext: self.context) as! Tag
        tag.name = name
        warehouse.tag.insert(tag)
    }
    
}