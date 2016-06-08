//
//  AppDelegate.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 6/1/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let navigationController = self.window!.rootViewController as! UINavigationController
        let viewController = navigationController.topViewController as! ViewController
        
        viewController.managedContext = coreDataStack.context
        
        return true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        coreDataStack.saveContext()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        coreDataStack.saveContext()
    }
}