//
//  ManagerTest.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/12/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import CoreData
import discount_ascii_warehouse

class TestCoreDataStack: CoreDataStack {
    override init() {
        super.init()
        self.psc = {
            let psc = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            
            do {
                try psc.addPersistentStoreWithType(
                                NSInMemoryStoreType,
                                configuration: nil,
                                URL: nil,
                                options: nil)
            } catch {
                fatalError()
            }
            
            return psc
        }()
    }
}