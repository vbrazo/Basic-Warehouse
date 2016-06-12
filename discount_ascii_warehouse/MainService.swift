//
//  MainService.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/12/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import CoreData
import SwiftyJSON

public class MainService {
    
    public let global = GlobalHelper()
    public let coreDataStack: CoreDataStack
    public let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.context = context
        self.coreDataStack = coreDataStack
    }
    
}