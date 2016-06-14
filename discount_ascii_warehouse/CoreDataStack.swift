//
//  CoreDataStack.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/7/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import CoreData

public class CoreDataStack {
    
    public init() {
        
    }
    
    private let modelName = "discount_ascii_warehouse"
    
    public func newPrivateQueueContext() -> NSManagedObjectContext {
        let privateQueueContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateQueueContext.parentContext = self.mainContext
        privateQueueContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return privateQueueContext
    }
    
    public lazy var mainContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.parentContext = self.masterContext
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return managedObjectContext
    }()

    private lazy var masterContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.psc
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return managedObjectContext
    }()
    
    public func saveContext(context: NSManagedObjectContext) {
        context.performBlockAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("ERROR saving context \(context.description) - \(error)")
                }
            }
            if let parentContext = context.parentContext {
                self.saveContext(parentContext)
            }
        }
    }
    
    public lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    public lazy var psc: NSPersistentStoreCoordinator = {
            
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.modelName)
            
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption : true]
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url,
                    options: options)
        } catch  {
            print("Error adding persistent store.")
        }
            
        return coordinator
    
    }()
    
}